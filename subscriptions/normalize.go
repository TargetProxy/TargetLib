package subscriptions

import (
	"net/url"
	"regexp"
	"strings"
)

// nestedURLKeys are the query parameter names that commonly carry the real
// subscription URL inside client import links (clash://, quantumult-x://...).
var nestedURLKeys = []string{
	"url", "uri", "link", "subscription", "sub", "subscribe",
	"remote-resource", "config", "target", "u",
}

var (
	embeddedEncodedURLPattern = regexp.MustCompile(`(?i)https?%3A%2F%2F[^\s&?#]\S*`)
	embeddedPlainURLPattern   = regexp.MustCompile("(?i)https?://[^\\s<>\"`]+")
	trailingPunctuation       = regexp.MustCompile(`[),.;]+$`)
	urlDecorations            = regexp.MustCompile(`^<+|>+$`)
)

// maxNormalizeDepth bounds recursion on nested/encoded inputs so hostile
// payloads cannot induce unbounded work.
const maxNormalizeDepth = 8

// NormalizeSubscriptionURL extracts a canonical subscription URL from raw
// user input: nested import links, multi-layer percent-encoding, base64-free
// decorations and embedded URLs are unwrapped before validation. It mirrors
// the normalization the desktop client used to perform before AddSubscription.
func NormalizeSubscriptionURL(input string) (string, error) {
	normalized, ok := normalizeSubscriptionURL(input, 0)
	if !ok {
		return "", ErrInvalidURL
	}
	return normalized, nil
}

func normalizeSubscriptionURL(input string, depth int) (string, bool) {
	if depth > maxNormalizeDepth {
		return "", false
	}
	trimmed := urlDecorations.ReplaceAllString(strings.TrimSpace(input), "")
	if trimmed == "" {
		return "", false
	}

	parsed, err := url.Parse(trimmed)
	if err == nil && isHTTPURL(parsed) {
		return parsed.String(), true
	}

	if err == nil && parsed != nil {
		query := parsed.Query()
		for _, key := range nestedURLKeys {
			value := query.Get(key)
			if value == "" {
				continue
			}
			if normalized, ok := normalizeSubscriptionURL(value, depth+1); ok {
				return normalized, true
			}
		}
		// Go already percent-decodes Fragment once during Parse; decode a
		// second time to match the legacy client behavior of decoding the
		// already-decoded fragment component again.
		if parsed.Fragment != "" {
			if decoded, err := url.PathUnescape(parsed.Fragment); err == nil {
				if normalized, ok := normalizeSubscriptionURL(decoded, depth+1); ok {
					return normalized, true
				}
			}
		}
	}

	return extractEmbeddedURL(trimmed, depth)
}

func extractEmbeddedURL(input string, depth int) (string, bool) {
	current := input
	for i := 0; i < 3; i++ {
		if match := embeddedEncodedURLPattern.FindString(current); match != "" {
			if decoded, err := url.PathUnescape(match); err == nil {
				if normalized, ok := normalizeSubscriptionURL(decoded, depth+1); ok {
					return normalized, true
				}
			}
		}

		if match := embeddedPlainURLPattern.FindString(current); match != "" {
			candidate := trailingPunctuation.ReplaceAllString(match, "")
			if parsed, err := url.Parse(candidate); err == nil && isHTTPURL(parsed) {
				return parsed.String(), true
			}
		}

		decoded, err := url.PathUnescape(current)
		if err != nil || decoded == current {
			break
		}
		current = decoded
	}
	return "", false
}

func isHTTPURL(parsed *url.URL) bool {
	return parsed != nil &&
		(parsed.Scheme == "http" || parsed.Scheme == "https") &&
		parsed.Host != ""
}

package subscriptions

import (
	"net/url"
	"regexp"
	"strings"
)

// nestedURLKeys 是客户端导入链接（clash://、quantumult-x:// 等）中常见的真实订阅 URL 参数名。
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

// maxNormalizeDepth 限制嵌套或编码输入的递归深度，避免恶意载荷导致无界工作量。
const maxNormalizeDepth = 8

// NormalizeSubscriptionURL 从用户原始输入中提取规范订阅 URL：验证前会展开嵌套导入链接、
// 多层百分号编码、无 base64 装饰和内嵌 URL，与桌面端 AddSubscription 前的行为一致。
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
		// Parse 已对 Fragment 做过一次百分号解码；再次解码以兼容旧客户端行为。
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

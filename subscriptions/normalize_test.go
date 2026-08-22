package subscriptions

import "testing"

func TestNormalizeSubscriptionURL(t *testing.T) {
	cases := []struct {
		name    string
		input   string
		want    string
		wantErr bool
	}{
		{name: "plain https", input: "https://example.com/sub", want: "https://example.com/sub"},
		{name: "host only", input: "https://example.com", want: "https://example.com"},
		{name: "decorated", input: "<https://example.com/sub>", want: "https://example.com/sub"},
		{name: "clash nested", input: "clash://install-config?url=https%3A%2F%2Fexample.com%2Fsub", want: "https://example.com/sub"},
		{name: "quantumult nested", input: "quantumult-x:///update-configuration?remote-resource=https%3A%2F%2Fexample.com%2Fqx", want: "https://example.com/qx"},
		{name: "embedded encoded", input: "subscribe to https%3A%2F%2Fexample.com%2Fsub now", want: "https://example.com/sub"},
		{name: "embedded plain", input: "link: https://example.com/sub.", want: "https://example.com/sub"},
		{name: "empty", input: "   ", wantErr: true},
		{name: "not a url", input: "hello world", wantErr: true},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			got, err := NormalizeSubscriptionURL(tc.input)
			if tc.wantErr {
				if err == nil {
					t.Fatalf("expected error, got %q", got)
				}
				return
			}
			if err != nil {
				t.Fatalf("unexpected error: %v", err)
			}
			if got != tc.want {
				t.Fatalf("got %q, want %q", got, tc.want)
			}
		})
	}
}

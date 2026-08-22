package manager

import "github.com/loafman1120/TargetLib/subscriptions"

const ProtocolVersion uint32 = 3

type Options struct {
	BasePath    string
	WorkingPath string
	TempPath    string
	Locale      string
	LogMaxLines int
	Debug       bool
	OOMKiller   bool
	// SubscriptionStore is owned and closed by Manager when it implements io.Closer.
	// A nil store selects in-memory storage, which is suitable for mobile hosts that
	// have not injected an Android Keystore or Apple Keychain backed Badger store.
	SubscriptionStore subscriptions.Store
}

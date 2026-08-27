package manager

import "github.com/loafman1120/TargetLib/subscriptions"

const ProtocolVersion uint32 = 9

type Options struct {
	BasePath    string
	WorkingPath string
	TempPath    string
	Locale      string
	LogMaxLines int
	Debug       bool
	OOMKiller   bool
	// Manager 负责拥有并关闭实现 io.Closer 的 SubscriptionStore。
	// store 为 nil 时使用内存存储，适合尚未注入 Android Keystore 或 Apple Keychain
	// 支持的 Badger 存储的移动端宿主。
	SubscriptionStore subscriptions.Store
}

package manager

const ProtocolVersion uint32 = 1

type Options struct {
	BasePath    string
	WorkingPath string
	TempPath    string
	Locale      string
	LogMaxLines int
	Debug       bool
	OOMKiller   bool
}

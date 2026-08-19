package systemproxy

// Status describes the current operating system proxy state.
type Status struct {
	Platform      string `json:"platform"`
	Supported     bool   `json:"supported"`
	Enabled       bool   `json:"enabled"`
	Server        string `json:"server,omitempty"`
	Bypass        string `json:"bypass,omitempty"`
	HasSavedState bool   `json:"hasSavedState"`
}

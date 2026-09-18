package targetlib

import (
	"google.golang.org/protobuf/proto"
	"testing"
)

func TestServiceSelectionPolicyRoundTrip(t *testing.T) {
	in := &ServiceSelectionPolicy{ServiceId: "svc", PreferredCountries: []string{"JP"}, AllowDirect: true, MaxCandidates: 8, Revision: "r1"}
	b, err := proto.Marshal(in)
	if err != nil {
		t.Fatal(err)
	}
	out := new(ServiceSelectionPolicy)
	if err := proto.Unmarshal(b, out); err != nil {
		t.Fatal(err)
	}
	if !proto.Equal(in, out) {
		t.Fatalf("round trip mismatch: %v", out)
	}
}

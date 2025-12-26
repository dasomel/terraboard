// Package version provides Terraform version information for Terraboard.
// This package was created to eliminate the dependency on the external
// github.com/hashicorp/terraform/version package, which uses go:embed
// in newer Terraform versions (1.7+).
package version

import (
	version "github.com/hashicorp/go-version"
)

// This constant defines which Terraform state format version this build
// of Terraboard is compatible with. Terraboard can read state files
// from versions up to and including this version.
const TerraformVersion = "1.13.5"

var (
	// Version is the main version string
	Version string

	// Prerelease is the pre-release marker
	Prerelease string = ""

	// SemVer is a version.Version representation
	SemVer *version.Version
)

func init() {
	SemVer = version.Must(version.NewVersion(TerraformVersion))
	Version = SemVer.String()
}

// Header is the header name used to send the current terraform version
// in http requests.
const Header = "Terraform-Version"

// String returns the complete version string, including prerelease
func String() string {
	if Prerelease != "" {
		return Version + "-" + Prerelease
	}
	return Version
}

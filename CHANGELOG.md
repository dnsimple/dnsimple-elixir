# Changelog

#### master

- CHANGED: Dates are represented as `DateTime.t`

#### Release 1.2.0

- NEW: Configuration setting for base URL (GH-113)
- NEW: Added Let's Encrypt certificate methods (GH-118)

- CHANGED: Updated dependencies.

- REMOVED: Removed premium_price attribute from registrar order responses (GH-120). Please do not rely on that attribute, as it returned an incorrect value. The attribute is going to be removed, and the API now returns a null value.


#### Release 1.1.1

- CHANGED: Relax poison dependency to fix incompatibility with Phoenix (GH-110)
- CHANGED: Update registrar endpoint URLs (GH-112)


#### Release 1.1.0

 - NEW: Add support for DNSSEC endpoints (GH-109)

 - CHANGED: Updated poison to 3.1.0
 - CHANGED: Updated httpoison to 0.11.1


#### Release 1.0.1

- NEW: Fix compilation warnings on Elixir 1.4.0 (GH-106)
- NEW: Added `unicode_name` to `Dnsimple.Domain` struct (GH-104)

- CHANGED: Improve and unify documentation styles (GH-101)


#### Release 1.0.0

- NEW: Added support for get domain premium price endpoint (GH-87)
- NEW: Added request logging (GH-81)
- NEW: Added support for collaborator endpoints (GH-74)
- NEW: Added support to zone records regions (GH-72)
- NEW: Added new attributes to TLDs (GH-69)

- CHANGED: Removed function aliases for simplicity (GH-95)
- CHANGED: Updated structs to reflect latest APIv2 payloads (GH-94)
- CHANGED: Updated registration, transfer, renewal response payload (dnsimple/dnsimple-developer#111, dnsimple/dnsimple-elixir#88)
- CHANGED: Being able to provide settings when applying a service (GH-77)
- CHANGED: Updated httpoison to 0.10.0 (GH-75)


#### Release 0.9.2

- CHANGED: increased timeout to 30 seconds (GH-67)


#### Release 0.9.1

- NEW: Added support for pushes (GH-65)
- NEW: Added support for vanity name server endpoints (GH-60)
- NEW: Added support to get zone files (GH-58)
- NEW: Added support for email forward endpoints (GH-56)
- NEW: Added support for delegation endpoints (GH-55)
- NEW: Complete support of service endpoints (GH-53)
- NEW: Added support for template endpoints (GH-51)
- NEW: Added support for TLD endpoints (GH-49)

- CHANGED: Added aliases and consolidate function naming (GH-47)


#### Release 0.9.0

- NEW: Added function to start OTP app (GH-45)
- NEW: Added support for contact endpoints (GH-38)
- NEW: Added reset domain token endpoint support (GH-37)
- NEW: Added support for accounts (GH-29)
- NEW: Added support for filtering and sorting (GH-19)
- NEW: Added support for domain services (GH-24)
- NEW: Added support for certificates (GH-26)
- NEW: Added support for webhooks (GH-27)
- NEW: Added support for OAuth dance (GH-12)
- NEW: Added support for whois privacy (GH-6)
- NEW: Added support for domain auto renewal (GH-5)

- CHANGED: Setting a custom user-agent no longer overrides the original user-agent (GH-15)
- CHANGED: Renamed Record struct to ZoneRecord (GH-18).

- REMOVED: Removed support for wildcard accounts (GH-16).


#### Release 0.1.0

- NEW: Added support for Zone, Domain, ZoneRecord


#### Release 0.0.1

Initial version.

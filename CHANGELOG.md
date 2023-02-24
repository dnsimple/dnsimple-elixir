# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## main

- NEW: Added `Dnsimple.Registrar.get_domain_registration/5` to retrieve a domain registration. (dnsimple/dnsimple-elixir#216)
- NEW: Added `Dnsimple.Registrar.get_domain_renewal/5` to retrieve a domain renewal. (dnsimple/dnsimple-elixir#216)

### Release 3.2.1

- CHANGED: Expose all information available in error responses (dnsimple/dnsimple-elixir#197)
- CHANGED: Deprecate Certificate's `contact_id` (dnsimple/dnsimple-elixir#186)

### Release 3.1.1

- CHANGED: Grouped module docs to make them easier to navigate (dnsimple/dnsimple-elixir#176).

### Release 3.1.0

- CHANGED: Updated DNSSEC-related structs and entry-points to support DS record key-data interface. (dnsimple/dnsimple-elixir#171)
- CHANGED: Switched CI to GitHub Actions

### Release 3.0.2

- CHANGED: adjust mix application configuration to only explicitly list `extra_applications` - Fixes #160

### Release 3.0.1

- CHANGED: Deprecated `Dnsimple.Registrar.get_domain_premium_price`.

## Release 3.0.0

- REMOVED: Deprecated attribute `expires_on` has been removed from `Dnsimple.Domain` (dnsimple/dnsimple-elixir#156)
- CHANGED: Fix warning about ExvcrUtils (dnsimple/dnsimple-elixir#139)
- CHANGED: `Dnsimple.Domain` struct now has `expires_at` (timestamp) to be used in favor of `expires_on` (date only).
  (dnsimple/dnsimple-elixir#135)
- CHANGED: `Dnsimple.Certificate` struct now has `expires_at` (timestamp) to be used in favor of `expires_on` (date only).
  (dnsimple/dnsimple-elixir#137)
- REMOVED: `Dnsimple.Domain.reset_domain_token` endpoint no longer exists and the client method is removed.
  (dnsimple/dnsimple-elixir#153)
- NEW: Added `Dnsimple.Registrar.get_domain_prices` to retrieve whether a domain is premium and the prices to register, transfer, and renew. (dnsimple/dnsimple-elixir#154)

## Release 2.0.0

- NEW: Added `Dnsimple.Registrar.get_domain_transfer/5` to retrieve a domain transfer. (dnsimple/dnsimple-elixir#133)
- NEW: Added `Dnsimple.Registrar.cancel_domain_transfer/5` to cancel an in progress domain transfer. (dnsimple/dnsimple-elixir#133)
- NEW: Added `status_description` to `Dnsimple.DomainTransfer` struct to identify the failure reason of a transfer. (dnsimple/dnsimple-elixir#133)

- CHANGED: Requires Elixir >= 1.6.

## Release 1.4.1

- CHANGED: Fix compilation warning (GH-125).
- CHANGED: User-agent format has been changed to prepend custom token before default token.

## Release 1.4.0

- NEW: Added WHOIS privacy renewal (GH-123)

## Release 1.3.0

- NEW: Added zone distribution and zone record distribution (GH-115)

## Release 1.2.0

- NEW: Configuration setting for base URL (GH-113)
- NEW: Added Let's Encrypt certificate methods (GH-118)

- CHANGED: Updated dependencies.

- REMOVED: Removed premium_price attribute from registrar order responses (GH-120). Please do not rely on that attribute, as it returned an incorrect value. The attribute is going to be removed, and the API now returns a null value.

## Release 1.1.1

- CHANGED: Relax poison dependency to fix incompatibility with Phoenix (GH-110)
- CHANGED: Update registrar endpoint URLs (GH-112)

## Release 1.1.0

- NEW: Add support for DNSSEC endpoints (GH-109)

## Release 1.0.1

- NEW: Fix compilation warnings on Elixir 1.4.0 (GH-106)
- NEW: Added `unicode_name` to `Dnsimple.Domain` struct (GH-104)

- CHANGED: Improve and unify documentation styles (GH-101)

## Release 1.0.0

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

## Release 0.9.2

- CHANGED: increased timeout to 30 seconds (GH-67)

## Release 0.9.1

- NEW: Added support for pushes (GH-65)
- NEW: Added support for vanity name server endpoints (GH-60)
- NEW: Added support to get zone files (GH-58)
- NEW: Added support for email forward endpoints (GH-56)
- NEW: Added support for delegation endpoints (GH-55)
- NEW: Complete support of service endpoints (GH-53)
- NEW: Added support for template endpoints (GH-51)
- NEW: Added support for TLD endpoints (GH-49)

- CHANGED: Added aliases and consolidate function naming (GH-47)

## Release 0.9.0

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

## Release 0.1.0

- NEW: Added support for Zone, Domain, ZoneRecord

## Release 0.0.1

Initial version.

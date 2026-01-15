# Changelog

This project uses [Semantic Versioning 2.0.0](http://semver.org/), the format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## Unreleased

### Changed

- Minimum OTP version is now 26
- Minimum Elixir version is now 1.16
- Added support for Elixir 1.19
- Added support for OTP 28

### Removed

- Removed deprecated `get_domain_premium_price`. Use `get_domain_prices` instead.
- Removed deprecated `get_whois_privacy` (dnsimple/dnsimple-developer#919)
- Removed deprecated `renew_whois_privacy` (dnsimple/dnsimple-developer#919)
- Dropped support for OTP 25 (EOL)
- Dropped support for Elixir 1.14 and 1.15 (EOL)

## 7.0.1

### Changed

- Handle HTTP response headers case-insensitively to support Rack 3.0 lowercase headers

## 7.0.0

### Added

- Add active attribute to EmailForward model (#286)

### Changed

- Remove from and to from EmailForward model (#288)
- Remove domain collaborator endpoints (#285)

### Housekeeping

- Bump dialyxir from 1.4.5 to 1.4.6 (#283)
- Bump exvcr from 0.17.0 to 0.17.1 (#274)
- Bump ex_doc from 0.37.3 to 0.38.2 (#273)

## 6.0.1

### Housekeeping

- Bump httpoison from 2.2.1 to 2.2.3 (#271)
- Bump exvcr from 0.15.1 to 0.17.0 (#270)
- Bump ex_doc from 0.34.1 to 0.37.3 (#269)

## 6.0.0

### Added

- Added support for Elixir 1.18

### Changed

- Requires Elixir >= 1.14 and OTP >= 25

### Fixed

- Fixed Elixir versions explicited in CHANGELOG.md and README.md

## 5.0.1

- Test build

## 5.0.0

### Added

- Added `alias_email` and `destination_email` to `Dnsimple.EmailForward`
- Added support for Elixir 1.17

### Changed

- Requires Elixir >= 1.13 and OTP >= 23

### Deprecated

- `DomainCollaborators` have been deprecated and will be removed in the next major version. Please use our Domain Access Control feature.

## 4.0.0

### Added

- Added support for Elixir 1.16

### Changed

- Requires Elixir >= 1.12 and OTP >= 22

## 3.8.0

### Added

- Added `Dnsimple.Registrar.enable_domain_transfer_lock` to enable the domain transfer lock for a domain. (#244)
- Added `Dnsimple.Registrar.disable_domain_transfer_lock` to disable the domain transfer lock for a domain. (#244)
- Added `Dnsimple.Registrar.get_domain_transfer_lock` to get the domain transfer lock status for a domain. (#244)

## 3.7.0

### Added

- Added `secondary`, `last_transferred_at`, `active` to `Zone` (#242)

## 3.6.0

### Added

- Added `Dnsimple.Billing.list_charges` to list charges for the account. (dnsimple/dnsimple-elixer#239)
- Added `Dnsimple.Registrar.check_registrant_change` to retrieves the requirements of a registrant change. (#241)
- Added `Dnsimple.Registrar.get_registrant_change` to retrieves the details of an existing registrant change. (#241)
- Added `Dnsimple.Registrar.create_registrant_change` to start registrant change. (#241)
- Added `Dnsimple.Registrar.list_registrant_changes` to lists the registrant changes for a domain. (#241)
- Added `Dnsimple.Registrar.delete_registrant_change` to cancel an ongoing registrant change from the account. (#241)

## 3.5.0

### Added

- Added `Dnsimple.Zone.activate_dns/4` to activate DNS services (resolution) for a zone. (#231)
- Added `Dnsimple.Zone.deactivate_dns/4` to deactivate DNS services (resolution) for a zone. (#231)

### Notes

- Elixir 1.15 has been added to the CI Test Matrix
- Elixir 1.10 has been dropped from the CI Test Matrix, while we still support it at the present time, we will no longer test against it and cannot guarantee it will continue to work. We support the last 5 Elixir releases only.

## 3.4.0

### Added

- Added `Dnsimple.Client.new_from_env` to initialize a client from the Application environment. (#219)

### Deprecated

- Deprecate `Dnsimple.Zone.File` use instead `Dnsimple.ZoneFile`. (#219)

## 3.3.0

### Added

- Added `Dnsimple.Registrar.get_domain_registration/5` to retrieve a domain registration. (#216)
- Added `Dnsimple.Registrar.get_domain_renewal/5` to retrieve a domain renewal. (#216)
- Added documentation for the new `signature_algorithm` parameter for the Let's Encrypt Purchase endpoint (#215)

## 3.2.1

### Changed

- Expose all information available in error responses (#197)

### Deprecated

- Deprecate Certificate's `contact_id` (#186)

## 3.1.1

### Changed

- Grouped module docs to make them easier to navigate (#176).

## 3.1.0

### Changed

- Updated DNSSEC-related structs and entry-points to support DS record key-data interface. (#171)
- Switched CI to GitHub Actions

## 3.0.2

### Changed

- adjust mix application configuration to only explicitly list `extra_applications` - Fixes #160

## 3.0.1

### Deprecated

- Deprecated `Dnsimple.Registrar.get_domain_premium_price`.

## 3.0.0

### Added

- Added `Dnsimple.Registrar.get_domain_prices` to retrieve whether a domain is premium and the prices to register, transfer, and renew. (#154)

### Changed

- Fix warning about ExvcrUtils (#139)
- `Dnsimple.Domain` struct now has `expires_at` (timestamp) to be used in favor of `expires_on` (date only). (#135)
- `Dnsimple.Certificate` struct now has `expires_at` (timestamp) to be used in favor of `expires_on` (date only). (#137)

### Removed

- Deprecated attribute `expires_on` has been removed from `Dnsimple.Domain` (#156)
- `Dnsimple.Domain.reset_domain_token` endpoint no longer exists and the client method is removed. (#153)

## 2.0.0 - 2020-05-21

### Added

- `Dnsimple.Registrar.get_domain_transfer/5` to retrieve a domain transfer. (#133)
- `Dnsimple.Registrar.cancel_domain_transfer/5` to cancel an in progress domain transfer. (#133)
- `status_description` to `Dnsimple.DomainTransfer` struct to identify the failure reason of a transfer. (#133)

### Changed

- Requires Elixir >= 1.6.

## 1.4.1 - 2020-02-11

### Changed

- User-agent format has been changed to prepend custom token before default token.

### Fixed

- Fix compilation warning (#125).

## 1.4.0 - 2019-02-01

### Added

- WHOIS privacy renewal (#123)

## 1.3.0 - 2018-10-16

### Added

- Zone distribution and zone record distribution (#115)

## 1.2.0 - 2018-01-28

### Added

- Configuration setting for base URL (#113)
- Let's Encrypt certificate methods (#118)

### Changed

- Updated dependencies.

### Removed

- Removed premium_price attribute from registrar order responses (#120). Please do not rely on that attribute, as it returned an incorrect value. The attribute is going to be removed, and the API now returns a null value.

## 1.1.1 - 2017-06-26

### Changed

- Update registrar endpoint URLs (#112)

### Fixed

- Relax poison dependency to fix incompatibility with Phoenix (#110)

## 1.1.0 - 2017-03-22

### Added

- Support for DNSSEC endpoints (#109)

## 1.0.1 - 2017-02-01

### Added

- `unicode_name` to `Dnsimple.Domain` struct (#104)

### Changed

- Improve and unify documentation styles (#101)

### Fixed

- Fix compilation warnings on Elixir 1.4.0 (#106)

## 1.0.0 - 2016-12-12

### Added

- Support for get domain premium price endpoint (#87)
- Request logging (#81)
- Support for collaborator endpoints (#74)
- Support to zone records regions (#72)
- New attributes to TLDs (#69)

### Changed

- Removed function aliases for simplicity (#95)
- Updated structs to reflect latest APIv2 payloads (#94)
- Updated registration, transfer, renewal response payload (dnsimple/dnsimple-developer#111, #88)
- Being able to provide settings when applying a service (#77)
- Updated httpoison to 0.10.0 (#75)

## 0.9.2 - 2016-09-22

### Changed

- Increased timeout to 30 seconds (#67)

## 0.9.1 - 2016-09-20

### Added

- Support for pushes (#65)
- Support for vanity name server endpoints (#60)
- Support to get zone files (#58)
- Support for email forward endpoints (#56)
- Support for delegation endpoints (#55)
- Complete support of service endpoints (#53)
- Support for template endpoints (#51)
- Support for TLD endpoints (#49)

### Changed

- Added aliases and consolidate function naming (#47)

## 0.9.0 - 2016-09-06

### Added

- Function to start OTP app (#45)
- Support for contact endpoints (#38)
- Reset domain token endpoint support (#37)
- Support for accounts (#29)
- Support for filtering and sorting (#19)
- Support for domain services (#24)
- Support for certificates (#26)
- Support for webhooks (#27)
- Support for OAuth dance (#12)
- Support for whois privacy (#6)
- Support for domain auto renewal (#5)

### Changed

- Setting a custom user-agent no longer overrides the original user-agent (#15)
- Renamed Record struct to ZoneRecord (#18).

### Removed

- Removed support for wildcard accounts (#16).

## 0.1.0 - 2016-05-10

### Added

- Support for Zone, Domain, ZoneRecord

## 0.0.1 - 2016-01-10

Initial version.

# Security Threat Model

## Asset Definition & Scope

-   **Asset Name:** GMA SDK (Flutter) - Mediation Adapters
-   **Path:** `google3/third_party/dart/google_mobile_ads_mediation/`
-   **Description:** Associated mediation adapters bridging the Flutter Google
    Mobile Ads SDK with third-party ad networks (AppLovin, Meta, Unity, etc.).

## Prioritization Signals

-   **1P OSS:** Yes (Google-owned open-source Flutter mediation adapters)
-   **1P Proprietary Shipped Software:** No (distributed as open-source package
    plugins)
-   **High-Risk Code Surface:** Yes (bridges to external 3rd party network SDKs
    and maps dynamic configuration extras)
-   **Perimeter Exposure:** No
-   **Data Sensitivity:** Medium (handles ad network integration keys,
    parameters, and user targeting options)
-   **Untrusted Input Handling:** Yes (accepts option mappings from the
    publisher's Flutter/Dart application)
-   **Business Value:** Crucial for maximizing publisher ad revenue by mediating
    multiple ad sources in Flutter apps

## Scanning Harness Prompts

-   Analyze each mediation adapter package (e.g., `gma_mediation_applovin`,
    `gma_mediation_meta`) to ensure class mappings returned by
    `getAndroidClassName` match companion classes implementing
    `FlutterMediationExtras`. Inspect for potential runtime casting exceptions
    or dynamic classloading vulnerabilities.
-   Verify that third-party ad configuration keys or user metrics are handled
    safely without accidental plain-text exposure in log files.

## Entry Points and Untrusted Inputs

Entry Point                             | Type                     | Trusted? | Validation
--------------------------------------- | ------------------------ | -------- | ----------
`MediationExtras.getExtras`             | Dart configuration map   | No       | Values are packaged in maps and sent over the method channel; parsed on the native side where types are validated individually (e.g., `isMuted is Boolean`)
`getAndroidClassName`/`getIOSClassName` | ClassName string mapping | No       | Used to resolve the companion class dynamically on the native side; could lead to instantiation issues if mapping returns an arbitrary/unexpected class

## Trust Boundaries and Auth Assumptions

-   **Authentication**: None (local execution bridge)
-   **Authorization**: None
-   **Implicit trust**: Assumes that class paths returned by the adapters are
    verified.

## Sensitive Data Paths

| Data Type      | Source       | Destination        | Protection           |
| -------------- | ------------ | ------------------ | -------------------- |
| Adapter custom | Dart adapter | Native third-party | Formatted as bundles |
: options (e.g., : client API   : SDK configuration  : and passed to        :
: mute audio,    :              :                    : underlying network   :
: targeting)     :              :                    : libraries            :

## Privileged Actions

| Action              | Location                  | Guard                    |
| ------------------- | ------------------------- | ------------------------ |
| Dynamic mapping to  | `getAndroidClassName()` / | Native plugin checks     |
: native extras class : `getIOSClassName()` in    : implementation structure :
:                     : adapters                  : before setting extras    :

## Priority Review Areas

1.  Companion extras classes (e.g., `AppLovinFlutterMediationExtras.kt`): Verify
    safe extraction of data types from dictionary payloads to prevent
    application crashes.
2.  Validation of returned class name values to avoid loading arbitrary classes
    if the Dart layer gets manipulated.

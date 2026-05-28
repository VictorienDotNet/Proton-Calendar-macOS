# Proton Calendar macOS

A dedicated macOS app for [Proton Calendar](1). Proton Calendar no longer has the obligation to share its window with Proton Mail. You can now open Proton Calendar in a separate window. 

[Download the App](https://link.victorien.net/proton-calendar-mac-os/app.zip)


## Behavior

It’s a simple Webview that opens calendar.proton.me. It stays signed in and doesn't cache any app assets. It doesn't accept other URLs than proton.me and will open in an external browser any external website, like a Zoom meeting for example.

## Developement 

This app was made with Cursor Agent. I review it, but be aware that I am not a macOS developer, rather a web developer. So the code might not be the most optimised and appropriate.

In order to build the app, you need Xcode. Once you have it, you can prepare the build and create the package with the following command:

```
swift build -c release && ./scripts/package.sh
```




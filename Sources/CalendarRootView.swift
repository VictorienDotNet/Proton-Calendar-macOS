import SwiftUI

struct CalendarRootView: View {
    var body: some View {
        ProtonWebView(
            initialURL: URL(string: "https://calendar.proton.me/")!
           
            //https://account.proton.me/calendar
        )
        .background(WindowTitleHider())
        .ignoresSafeArea()
    }
}


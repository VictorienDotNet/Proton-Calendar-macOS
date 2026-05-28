import Foundation

enum NotificationForwardingScript {
    static let messageHandlerName = "nativeNotify"

    static let source = """
(function() {
  if (window.__nativeNotifyInstalled) return;
  window.__nativeNotifyInstalled = true;

  function post(payload) {
    try {
      if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.\(messageHandlerName)) {
        window.webkit.messageHandlers.\(messageHandlerName).postMessage(payload);
      }
    } catch (_) {}
  }

  // Patch Notification API (common path)
  try {
    if (typeof window.Notification === "function") {
      const NativeNotification = window.Notification;

      function WrappedNotification(title, options) {
        const body = options && options.body ? String(options.body) : "";
        post({ type: "notification", title: String(title || ""), body });
        // Return a dummy object; most apps only use it for display.
        return {};
      }

      WrappedNotification.permission = "granted";
      WrappedNotification.requestPermission = function(cb) {
        try { if (cb) cb("granted"); } catch (_) {}
        return Promise.resolve("granted");
      };

      window.Notification = WrappedNotification;
      window.Notification.__nativeWrapped = true;
      window.__NativeNotificationOriginal = NativeNotification;
    }
  } catch (_) {}

  // Patch ServiceWorkerRegistration.showNotification (common modern path)
  try {
    if (window.ServiceWorkerRegistration && window.ServiceWorkerRegistration.prototype) {
      const orig = window.ServiceWorkerRegistration.prototype.showNotification;
      if (typeof orig === "function" && !orig.__nativeWrapped) {
        window.ServiceWorkerRegistration.prototype.showNotification = function(title, options) {
          const body = options && options.body ? String(options.body) : "";
          post({ type: "sw", title: String(title || ""), body });
          return Promise.resolve();
        };
        window.ServiceWorkerRegistration.prototype.showNotification.__nativeWrapped = true;
      }
    }
  } catch (_) {}
})();
"""
}


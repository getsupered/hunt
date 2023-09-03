import Toastify from 'toastify-js'

export const Notifications = {
  mounted() {
    this.handleEvent('notification', (notification) => {
      this.toastify(notification)
    })
  },

  toastify(notification) {
    /**
     * Toasts are placed on document.body to be outside of the LiveView root element. If inside of the
     * mounted element, the content is lost on page navigation.
     */
    const toast = Toastify({
      text: notification.text,
      className: `toast-notification toast-notification--${notification.type}`,
      duration: 5000,
      selector: undefined, // defaults to document.body if not provided
      close: true,
      onClick: () => {
        toast.hideToast()
      }
    })

    toast.showToast()
  }
}

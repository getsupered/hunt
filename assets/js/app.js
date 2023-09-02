// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import {Html5QrcodeScanner, Html5QrcodeSupportedFormats, Html5QrcodeScanType} from "html5-qrcode"

import topbar from "../vendor/topbar"

const hooks = {
  ImageCarousel: {
    mounted() {
      const splideEl = this.el.querySelector('.splide')

      this.splide = new Splide(splideEl, {
        type   : 'loop',
        // padding: '2rem',
        start: splideEl.dataset['startIndex'] || 0,
        flickMaxPages: 0.3 // bad name, actually more of a power multiplier
      })

      window.splideDebug = this.splide
      this.splide.mount()

      this.splide.on('active', (evt) => {
        if (!evt.isClone) {
          this.pushEvent('slide.active', { index: evt.index })
        }
      })
    },
    updated() {
      this.destroyed()
      this.mounted()
    },
    destroyed() {
      if (this.splide) {
        console.log('splide destroy')
        this.splide.destroy()
      }
    }
  },
  QRScanButton: {
    mounted() {
      this.el.addEventListener('click', () => {
        const evt = new CustomEvent('qrcode:start')
        window.dispatchEvent(evt)
      })
    }
  },
  QRScanner: {
    mounted() {
      document.getElementById('qr-scanner--cancel').addEventListener('click', () => {
        this.cleanUpScanner()
        this.el.children[0].classList.remove('!translate-y-0')
      })

      this.startFunction = () => {
        this.cleanUpScanner()

        this.html5QrcodeScanner = new Html5QrcodeScanner(
          'qr-scanner--reader',
          {
            fps: 10,
            qrbox: { width: 250, height: 250 },
            aspectRatio: 1.0,
            formatsToSupport: [ Html5QrcodeSupportedFormats.QR_CODE ],
            supportedScanTypes: [ Html5QrcodeScanType.SCAN_TYPE_CAMERA ],
            rememberLastUsedCamera: false
          },
          false
        )

        this.html5QrcodeScanner.render((text) => {
          this.cleanUpScanner()
          this.el.children[0].classList.remove('!translate-y-0')
        }, () => null)

        this.el.children[0].classList.add('!translate-y-0')
      }

      window.addEventListener('qrcode:start', this.startFunction)
    },
    updated() {
      this.destroyed()
      this.mounted()
    },
    destroyed() {
      this.cleanUpScanner()
      window.removeEventListener('qrcode:start', this.startFunction)
    },
    cleanUpScanner() {
      if (this.html5QrcodeScanner) {
        this.html5QrcodeScanner.clear()
        delete this.html5QrcodeScanner
      }
    }
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { params: {_csrf_token: csrfToken}, hooks })

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

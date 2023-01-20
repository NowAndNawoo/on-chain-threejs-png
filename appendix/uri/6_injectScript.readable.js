function injectScript(data) {
  // canvasタグを作成
  const canvas = document.createElement('canvas');
  const gl = canvas.getContext('webgl');
  // テクスチャを作成
  const texture = gl.createTexture();
  gl.bindTexture(gl.TEXTURE_2D, texture);
  // Imageを作成してdata(PNG画像)を読み込む
  const image = new Image();
  image.src = data;
  image.addEventListener('load', function () {
    const w = image.width;
    const h = image.height;
    // テクスチャを使用する準備(https://developer.mozilla.org/ja/docs/Web/API/WebGL_API/Tutorial/Using_textures_in_WebGL)
    gl.bindTexture(gl.TEXTURE_2D, texture);
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, image);
    gl.generateMipmap(gl.TEXTURE_2D);
    // フレームバッファを作成 (https://wgld.org/d/webgl/w040.html)
    const framebuffer = gl.createFramebuffer();
    gl.bindFramebuffer(gl.FRAMEBUFFER, framebuffer);
    // フレームバッファにテクスチャを割り当て
    gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, texture, 0);
    if (gl.checkFramebufferStatus(gl.FRAMEBUFFER) == gl.FRAMEBUFFER_COMPLETE) {
      const buffer = new Uint8Array(w * h * 4);
      // フレームバッファから一括でピクセルデータを読み込む (https://wgld.org/d/webgl/w086.html)
      gl.readPixels(0, 0, w, h, gl.RGBA, gl.UNSIGNED_BYTE, buffer);
      // ピクセルデータを文字列(JavaScriptコード)に変換して、Base64エンコード
      const decoder = new TextDecoder('utf-8');
      const b64 = btoa(decoder.decode(buffer));
      // scriptタグの作成
      const script = document.createElement('script');
      // srcにdataURL化したJavaScriptコードを指定
      script.setAttribute('src', 'data:text/javascript;base64,' + b64.trim());
      // documentにscriptタグを追加
      document.head.appendChild(script);
    }
    // canvasタグの削除
    canvas.remove();
  });
}
// data(PNG画像)を引数に渡して実行
injectScript(data);

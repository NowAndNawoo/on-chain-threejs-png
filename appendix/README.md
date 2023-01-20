# Appendix - RollerCoaster Details

- [OpenSea](https://testnets.opensea.io/ja/assets/goerli/0xfccef97532caa9ddd6840a9c87843b8d491370fc/1)
- [Tweet](https://twitter.com/xtremetom/status/1600542212735090711)
- [Etherscan](https://goerli.etherscan.io/address/0xfccef97532caa9ddd6840a9c87843b8d491370fc#code) (Main contract)
- [Etherscan](https://goerli.etherscan.io/address/0xE9fD6806AcCE0a8cBE80834A94019E92fCB7B06D) (LibraryStorage contract)

## Files

- png/
  - `1_RollerCoaster.png.b64`
    - Return value of `getLibrary('RollerCoaster')`
  - `2_RollerCoaster.png`
    - Base64 decoded file of above
  - `3_RollerCoaster.js`
    - JS code obtained by decompressing PNG
  - `4_RollerCoaster.prettify.js`
    - Prettified JS code
- uri/
  - `1_metadata.json`
    - Return value of `tokenURI(1)`
  - `2_animation_url.html`
    - The value of animation_url of json
  - `3_animation_url.prettify.html`
    - Prettified HTML
  - `4_injectScript.js`
    - Decoded dataURL of script tag in body tag
  - `5_injectScript.prettify.js`
    - Prettified JS code
  - `6_injectScript.readable.js`
    - Modified JS code for easier reading

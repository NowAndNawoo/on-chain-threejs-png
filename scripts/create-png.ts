import { readFileSync } from 'fs';
import Jimp from 'jimp';

// JSコードからPNG画像ファイルを作成
async function main() {
  const jsPath = './html/Sample1/dist/bundle.js';
  const pngPath = './output/sample1.png';

  // JSコードを読み込み
  const jsCode = readFileSync(jsPath, 'utf-8');
  const codeLength = jsCode.length;

  // 画像サイズとpadding(bytes)を求める
  const pixelCount = Math.ceil(codeLength / 4); // 1pixel=4bytes(RGBA)
  const w = Math.ceil(Math.sqrt(pixelCount)); // 正方形に近い形
  const h = Math.ceil(pixelCount / w);
  const padding = w * h * 4 - codeLength;

  // JSコードにpaddingを追加
  const jsCodeWithPadding = jsCode + ' '.repeat(padding);
  console.log({ codeLength, w, h, padding, codeWithPadding: jsCodeWithPadding.length });

  // PNGファイルの作成
  const png = await Jimp.create(w, h);
  png.bitmap.data = Buffer.from(jsCodeWithPadding);
  await png.writeAsync(pngPath);

  console.log('done!');
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

import { readFileSync, writeFileSync } from 'fs';
import { ethers } from 'hardhat';
import { waitDeployed, waitTx } from './lib/common';

const DATAURL_PREFIX_JSON = 'data:application/json,';
const DATAURL_PREFIX_HTML = 'data:text/html,';

async function main() {
  // signer
  const [signer] = await ethers.getSigners();
  console.log('signer:', signer.address);

  // LibraryStorageをデプロイ
  const libraryStorage = await ethers.getContractFactory('LibraryStorage').then((factory) => factory.deploy());
  await waitDeployed('LibraryStorage', libraryStorage);

  // PNGを分割してアップロード
  const chunkSize = 24256;
  const libraryName = 'Sample1';
  const pngPath = './output/Sample1.min.png';

  const png = readFileSync(pngPath);
  const b64 = png.toString('base64');
  const buffer = Buffer.from(b64);
  const chunkCount = Math.ceil(buffer.length / chunkSize);
  for (let i = 0; i < chunkCount; i++) {
    const start = i * chunkSize;
    const chunk = buffer.slice(start, start + chunkSize);
    const tx = await libraryStorage.addChunk(libraryName, chunk);
    await waitTx('addChunk ' + i, tx);
  }

  // ThreePngSample1をデプロイ
  const sample1 = await ethers
    .getContractFactory('ThreePngSample1')
    .then((factory) => factory.deploy(libraryStorage.address));
  await waitDeployed('Sample1', sample1);

  // mint
  const tx = await sample1.mint();
  await waitTx('mint', tx);

  // estimateGas
  const gas = await sample1.estimateGas.tokenURI(1);
  console.log('estimateGas:', gas.toNumber());
  const uri = await sample1.tokenURI(1);

  // get metadata
  const json = decodeURIComponent(uri.slice(DATAURL_PREFIX_JSON.length));
  const metadata = JSON.parse(json);
  writeFileSync('./output/1_metadata.json', json);

  // get animation_uri
  const html = decodeURIComponent(metadata.animation_url.slice(DATAURL_PREFIX_HTML.length));
  writeFileSync('./output/2_animation_url.html', html);

  console.log('done!');
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

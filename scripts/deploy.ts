import { readFileSync } from 'fs';
import { ethers } from 'hardhat';
import { waitDeployed, waitTx } from './lib/common';

async function main() {
  // signer
  const [signer] = await ethers.getSigners();
  console.log('signer:', signer.address);

  // LibraryStorageをデプロイ
  const libraryStorage = await ethers.getContractFactory('LibraryStorage').then((factory) => factory.deploy());
  await waitDeployed('LibraryStorage', libraryStorage);

  // PNGを分割してアップロード
  const chunkSize = 24575;
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

  console.log('done!');
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

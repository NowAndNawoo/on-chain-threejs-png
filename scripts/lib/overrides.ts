import { ethers } from 'hardhat';
import { Overrides } from 'ethers';
import { getEnvValueAsNumber } from './common';

export function getEIP1559Overrides(maxFeePerGas?: number, maxPriorityFeePerGas?: number): Overrides {
  if (maxFeePerGas === undefined) maxFeePerGas = getEnvValueAsNumber('MAX_FEE_PER_GAS');
  if (maxPriorityFeePerGas === undefined) maxPriorityFeePerGas = getEnvValueAsNumber('MAX_PRIORITY_FEE_PER_GAS');

  return {
    type: 2,
    maxFeePerGas: ethers.utils.parseUnits(maxFeePerGas.toString(), 'gwei'),
    maxPriorityFeePerGas: ethers.utils.parseUnits(maxPriorityFeePerGas.toString(), 'gwei'),
  };
}

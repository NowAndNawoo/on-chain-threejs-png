pragma solidity ^0.8.13;

// Original code by @xtremetom
// https://twitter.com/xtremetom/status/1600542212735090711
// https://goerli.etherscan.io/address/0xfccef97532caa9ddd6840a9c87843b8d491370fc#code#F2#L1
// Modified by nawoo (@NowAndNawoo)

import "@openzeppelin/contracts/access/Ownable.sol";
import "./SSTORE2.sol";

contract LibraryStorage is Ownable {
    mapping(string => address[]) public libraries;

    function addChunk(string calldata name, bytes calldata chunk) public onlyOwner {
        libraries[name].push(SSTORE2.write(chunk));
    }

    function getLibrary(string calldata name) public view returns (bytes memory result) {
        address[] memory chunks = libraries[name];
        unchecked {
            assembly {
                let len := mload(chunks)
                let totalSize := 0x20 // header size (32bytes)
                let size
                result := mload(0x40) // get free memory pointer
                let targetChunk
                for {
                    let i := 0
                } lt(i, len) {
                    i := add(i, 1)
                } {
                    // get chunks[i] pointer
                    targetChunk := mload(add(chunks, add(0x20, mul(i, 0x20))))
                    // copy chunks[i] data to result
                    size := sub(extcodesize(targetChunk), 1)
                    extcodecopy(targetChunk, add(result, totalSize), 1, size)
                    // update totalSize
                    totalSize := add(totalSize, size)
                }
                mstore(result, sub(totalSize, 0x20)) // set length
                mstore(0x40, add(result, and(add(totalSize, 0x1f), not(0x1f)))) // update free memory pointer
            }
        }
    }
}

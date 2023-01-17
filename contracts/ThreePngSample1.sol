// Original code by @xtremetom
// https://twitter.com/xtremetom/status/1600542212735090711
// https://goerli.etherscan.io/address/0xfccef97532caa9ddd6840a9c87843b8d491370fc#code#F1#L1
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./LibraryStorage.sol";

contract ThreePngSample1 is ERC721 {
    address private immutable _libStorageAddress;

    // HELPERS
    string public constant BEGIN_JSON = "data:application/json,%7B"; // data:application/json,{
    string public constant END_JSON = "%7D"; // }
    string public constant BEGIN_SCRIPT = "%253Cscript%253E"; // '<script>'
    string public constant END_SCRIPT = "%253C%252Fscript%253E"; // </script>
    string public constant BEGIN_SCRIPT_DATA = "%253Cscript%2520src%253D%2527"; // <script src='
    string public constant END_SCRIPT_DATA = "%2527%253E%253C%252Fscript%253E"; // '></script>

    uint256 private _nextId = 1;

    constructor(address libStorageAddress) ERC721("ThreePngSample1", "PNG1") {
        _libStorageAddress = libStorageAddress;
    }

    function mint() public {
        _mint(msg.sender, _nextId);
        unchecked {
            ++_nextId;
        }
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory tokenIdStr = uint2str(tokenId);
        return
            string.concat(
                BEGIN_JSON,
                string.concat(
                    BEGIN_METADATA_VAR("animation_url", false),
                    "data%3Atext%2Fhtml%2C", // data:text/html,
                    "%253Cstyle%253Ehtml%252Cbody%257Bpadding%253A0%253Bmargin%253A0%253B%257D%253C%252Fstyle%253E", // <style>...</style>
                    addCodeLibrariesAsImage(),
                    "%253Cbody%253E", // <body>
                    addRenderCode(),
                    "%253C%252Fbody%253E", // </body>
                    END_METADATA_VAR(false),
                    BEGIN_METADATA_VAR("name", false),
                    "PNG%20Sample%20",
                    tokenIdStr,
                    "%22",
                    END_JSON
                )
            );
    }

    function addRenderCode() internal pure returns (string memory) {
        return
            string.concat(
                BEGIN_SCRIPT_DATA,
                "data%253Atext%252Fjavascript%253Bbase64%252C", // data:text/javascript;base64,
                "ZnVuY3Rpb24gaW5qZWN0U2NyaXB0KGUpe2NvbnN0IHQ9ZG9jdW1lbnQuY3JlYXRlRWxlbWVudCgiY2FudmFzIikscj10LmdldENvbnRleHQoIndlYmdsIik7dmFyIGE9ci5jcmVhdGVUZXh0dXJlKCk7ci5iaW5kVGV4dHVyZShyLlRFWFRVUkVfMkQsYSk7dmFyIEU9bmV3IEltYWdlO0Uuc3JjPWUsRS5hZGRFdmVudExpc3RlbmVyKCJsb2FkIiwoZnVuY3Rpb24oKXt2YXIgZT1FLndpZHRoLG49RS5oZWlnaHQ7ci5iaW5kVGV4dHVyZShyLlRFWFRVUkVfMkQsYSksci50ZXhJbWFnZTJEKHIuVEVYVFVSRV8yRCwwLHIuUkdCQSxyLlJHQkEsci5VTlNJR05FRF9CWVRFLEUpLHIuZ2VuZXJhdGVNaXBtYXAoci5URVhUVVJFXzJEKTt2YXIgYz1yLmNyZWF0ZUZyYW1lYnVmZmVyKCk7aWYoci5iaW5kRnJhbWVidWZmZXIoci5GUkFNRUJVRkZFUixjKSxyLmZyYW1lYnVmZmVyVGV4dHVyZTJEKHIuRlJBTUVCVUZGRVIsci5DT0xPUl9BVFRBQ0hNRU5UMCxyLlRFWFRVUkVfMkQsYSwwKSxyLmNoZWNrRnJhbWVidWZmZXJTdGF0dXMoci5GUkFNRUJVRkZFUik9PXIuRlJBTUVCVUZGRVJfQ09NUExFVEUpe3ZhciBpPW5ldyBVaW50OEFycmF5KGUqbio0KTtyLnJlYWRQaXhlbHMoMCwwLGUsbixyLlJHQkEsci5VTlNJR05FRF9CWVRFLGkpO3ZhciBUPW5ldyBUZXh0RGVjb2RlcigidXRmLTgiKSxkPWJ0b2EoVC5kZWNvZGUoaSkpLFI9ZG9jdW1lbnQuY3JlYXRlRWxlbWVudCgic2NyaXB0Iik7Ui5zZXRBdHRyaWJ1dGUoInNyYyIsImRhdGE6dGV4dC9qYXZhc2NyaXB0O2Jhc2U2NCwiK2QudHJpbSgpKSxkb2N1bWVudC5oZWFkLmFwcGVuZENoaWxkKFIpfXQucmVtb3ZlKCl9KSl9aW5qZWN0U2NyaXB0KGRhdGEpOw==",
                END_SCRIPT_DATA
            );
    }

    function addCodeLibrariesAsImage() internal view returns (string memory) {
        LibraryStorage libraryStorage = LibraryStorage(_libStorageAddress);
        return
            string.concat(
                BEGIN_SCRIPT,
                "var%2520data%2520%253D%2520%2522", // var data = "
                "data%253Aimage%252Fpng%253Bbase64%252C", // data:image/png;base64,
                libraryStorage.getLibrary("Sample1"),
                "%2522%253B", // ";
                END_SCRIPT
            );
    }

    // via https://stackoverflow.com/a/65707309
    function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function BEGIN_METADATA_VAR(string memory name, bool omitQuotes) public pure returns (string memory) {
        return
            (omitQuotes)
                ? string(abi.encodePacked("%22", name, "%22%3A"))
                : string(abi.encodePacked("%22", name, "%22%3A%22"));
    }

    function END_METADATA_VAR(bool omitQuotes) public pure returns (string memory) {
        return (omitQuotes) ? "%2C" : "%22%2C";
    }
}

pragma solidity ^0.8.13;

// Original code by @xtremetom
// https://twitter.com/xtremetom/status/1600542212735090711
// https://goerli.etherscan.io/address/0xfccef97532caa9ddd6840a9c87843b8d491370fc#code#F1#L1
// Modified by nawoo (@NowAndNawoo)

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "./LibraryStorage.sol";

contract ThreePngSample1 is ERC721, Ownable {
    using Strings for uint256;

    LibraryStorage public immutable libraryStorage;
    uint256 public nextTokenId = 1;

    string private constant BEGIN_JSON = "data:application/json,%7B"; // data:application/json,{
    string private constant END_JSON = "%7D"; // }
    string private constant BEGIN_SCRIPT = "%253Cscript%253E"; // '<script>'
    string private constant END_SCRIPT = "%253C%252Fscript%253E"; // </script>
    string private constant BEGIN_SCRIPT_DATA = "%253Cscript%2520src%253D%2527"; // <script src='
    string private constant END_SCRIPT_DATA = "%2527%253E%253C%252Fscript%253E"; // '></script>

    constructor(LibraryStorage libraryStorageAddress) ERC721("ThreePngSample1", "PNG1") {
        libraryStorage = libraryStorageAddress;
    }

    function mint() public onlyOwner {
        uint256 _tokenId = nextTokenId;
        nextTokenId++;
        _mint(msg.sender, _tokenId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory tokenIdStr = tokenId.toString();
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

    function addRenderCode() private pure returns (string memory) {
        return
            string.concat(
                BEGIN_SCRIPT_DATA,
                "data%253Atext%252Fjavascript%253Bbase64%252C", // data:text/javascript;base64,
                "ZnVuY3Rpb24gaW5qZWN0U2NyaXB0KGUpe2NvbnN0IHQ9ZG9jdW1lbnQuY3JlYXRlRWxlbWVudCgiY2FudmFzIikscj10LmdldENvbnRleHQoIndlYmdsIik7dmFyIGE9ci5jcmVhdGVUZXh0dXJlKCk7ci5iaW5kVGV4dHVyZShyLlRFWFRVUkVfMkQsYSk7dmFyIEU9bmV3IEltYWdlO0Uuc3JjPWUsRS5hZGRFdmVudExpc3RlbmVyKCJsb2FkIiwoZnVuY3Rpb24oKXt2YXIgZT1FLndpZHRoLG49RS5oZWlnaHQ7ci5iaW5kVGV4dHVyZShyLlRFWFRVUkVfMkQsYSksci50ZXhJbWFnZTJEKHIuVEVYVFVSRV8yRCwwLHIuUkdCQSxyLlJHQkEsci5VTlNJR05FRF9CWVRFLEUpLHIuZ2VuZXJhdGVNaXBtYXAoci5URVhUVVJFXzJEKTt2YXIgYz1yLmNyZWF0ZUZyYW1lYnVmZmVyKCk7aWYoci5iaW5kRnJhbWVidWZmZXIoci5GUkFNRUJVRkZFUixjKSxyLmZyYW1lYnVmZmVyVGV4dHVyZTJEKHIuRlJBTUVCVUZGRVIsci5DT0xPUl9BVFRBQ0hNRU5UMCxyLlRFWFRVUkVfMkQsYSwwKSxyLmNoZWNrRnJhbWVidWZmZXJTdGF0dXMoci5GUkFNRUJVRkZFUik9PXIuRlJBTUVCVUZGRVJfQ09NUExFVEUpe3ZhciBpPW5ldyBVaW50OEFycmF5KGUqbio0KTtyLnJlYWRQaXhlbHMoMCwwLGUsbixyLlJHQkEsci5VTlNJR05FRF9CWVRFLGkpO3ZhciBUPW5ldyBUZXh0RGVjb2RlcigidXRmLTgiKSxkPWJ0b2EoVC5kZWNvZGUoaSkpLFI9ZG9jdW1lbnQuY3JlYXRlRWxlbWVudCgic2NyaXB0Iik7Ui5zZXRBdHRyaWJ1dGUoInNyYyIsImRhdGE6dGV4dC9qYXZhc2NyaXB0O2Jhc2U2NCwiK2QudHJpbSgpKSxkb2N1bWVudC5oZWFkLmFwcGVuZENoaWxkKFIpfXQucmVtb3ZlKCl9KSl9aW5qZWN0U2NyaXB0KGRhdGEpOw==",
                END_SCRIPT_DATA
            );
    }

    function addCodeLibrariesAsImage() private view returns (string memory) {
        return
            string.concat(
                BEGIN_SCRIPT,
                "var%2520data%2520%253D%2520%2522", // var data = "
                "data%253Aimage%252Fpng%253Bbase64%252C", // data:image/png;base64,
                string(libraryStorage.getLibrary("Sample1")),
                "%2522%253B", // ";
                END_SCRIPT
            );
    }

    function BEGIN_METADATA_VAR(string memory name, bool omitQuotes) private pure returns (string memory) {
        return
            (omitQuotes)
                ? string(abi.encodePacked("%22", name, "%22%3A"))
                : string(abi.encodePacked("%22", name, "%22%3A%22"));
    }

    function END_METADATA_VAR(bool omitQuotes) private pure returns (string memory) {
        return (omitQuotes) ? "%2C" : "%22%2C";
    }
}

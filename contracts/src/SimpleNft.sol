// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;
import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/utils/Counters.sol";


contract SimpleNft is ERC721, Ownable {

    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private supply;

    string public uriPrefix = "";
    string public uriSuffix = ".json";
    string public hiddenMetadataUri;

    uint256 public cost = 0 ether;
    uint256 public maxSupply = 5555;
    uint256 public maxMintAmountPerTx = 1;

    bool public revealed = false;


    mapping(uint256 => bool) isIdTaken;


    mapping(uint256 => string) imageUrls;
    mapping(uint256 => address) idToOwner;

    constructor() ERC721("SimpleNFT", "sNFT") {

        //AND HAVE TO SET THIS SO IT DEPENDS ON THE ID GIVEN
        setHiddenMetadataUri("");
        imageUrls[0]="https://bafkreihlnkvmbfbwzoya733vkvdo3inolj4qjzkr4p2mtlcxhcwr4uzvhi.ipfs.nftstorage.link/";
        imageUrls[1]="https://bafkreihdatoafdtbfopzf6zih4qwu76jdufgxhmymdsxk76pmx4kdz7i64.ipfs.nftstorage.link/";
        imageUrls[2]="https://bafkreifuek4nrpl2v64o7hzou2ch5xlgjthzygawr6ix5erw4lsuzt3jxm.ipfs.nftstorage.link/";
        imageUrls[2]="https://bafkreihlnkvmbfbwzoya733vkvdo3inolj4qjzkr4p2mtlcxhcwr4uzvhi.ipfs.nftstorage.link/";
       imageUrls[3]="https://bafkreibi4bwsrn5hjcv42wst6soqjxwlroue37hdblglqwvmjbeaa6pobe.ipfs.nftstorage.link/";
    }

    modifier mintCompliance(uint256 _mintAmount) {
        require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
        require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
        _;
    }

    function totalSupply() public view returns (uint256) {
        return supply.current();
    }

    function updateImageUrls(uint256 id, string memory url) public payable{
        require(msg.sender == idToOwner[id], "NO NO NO NO");
        imageUrls[id] = url;
    }


    function getImageUrls() public view returns (string[] memory) {
        string[] memory arr = new string[](9);
        arr[0] = imageUrls[1];
        arr[1] = imageUrls[2];
        arr[2] = imageUrls[3];
        arr[3] = imageUrls[4];
        arr[4] = imageUrls[5];
        arr[5] = imageUrls[6];
        arr[6] = imageUrls[7];
        arr[7] = imageUrls[8];
        arr[8] = imageUrls[9];
        return arr;
    }

    function mint(uint256 _tokenID) public payable mintCompliance(1) {
        require(msg.value >= cost, "Insufficient funds!");
        require(isIdTaken[_tokenID] == false, "This token has already been minted");

        isIdTaken[_tokenID] = true;
        idToOwner[_tokenID] = msg.sender;
        _mintLoop(msg.sender, 1, _tokenID);
    }

    function mintForAddress(uint256 _mintAmount, address _receiver, uint256 _tokenID) public mintCompliance(_mintAmount) onlyOwner {
        _mintLoop(_receiver, _mintAmount, _tokenID);
    }

    function walletOfOwner(address _owner)
    public
    view
    returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
        uint256 currentTokenId = 1;
        uint256 ownedTokenIndex = 0;

        while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
            address currentTokenOwner = ownerOf(currentTokenId);

            if (currentTokenOwner == _owner) {
                ownedTokenIds[ownedTokenIndex] = currentTokenId;

                ownedTokenIndex++;
            }

            currentTokenId++;
        }

        return ownedTokenIds;
    }

    function tokenURI(uint256 _tokenId)
    public
    view
    virtual
    override
    returns (string memory)
    {
        require(
            _exists(_tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        // if (revealed == false) {
        //     return hiddenMetadataUri;
        // }

        // string memory currentBaseURI = _baseURI();
        // return bytes(currentBaseURI).length > 0
        // ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
        // : "";

return imageUrls[_tokenId];


    }

    function setRevealed(bool _state) public onlyOwner {
        revealed = _state;
    }

    function setCost(uint256 _cost) public onlyOwner {
        cost = _cost;
    }

    function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
        maxMintAmountPerTx = _maxMintAmountPerTx;
    }

    function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
        hiddenMetadataUri = _hiddenMetadataUri;
    }

    function setUriPrefix(string memory _uriPrefix) public onlyOwner {
        uriPrefix = _uriPrefix;
    }

    function setUriSuffix(string memory _uriSuffix) public onlyOwner {
        uriSuffix = _uriSuffix;
    }

    function withdraw() public onlyOwner {
        // This will transfer the remaining contract balance to the owner.
        // Do not remove this otherwise you will not be able to withdraw the funds.
        // =============================================================================
        (bool os,) = payable(owner()).call{value : address(this).balance}("");
        require(os);
        // =============================================================================
    }

    function _mintLoop(address _receiver, uint256 _mintAmount, uint tokenID) internal {
        for (uint256 i = 0; i < _mintAmount; i++) {
            supply.increment();
            _safeMint(_receiver, tokenID);
        }
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return uriPrefix;
    }
}


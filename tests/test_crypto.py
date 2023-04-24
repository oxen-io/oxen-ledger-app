OXEN_VIEW_PUB_KEY    = "ed26f4f9ed44baccb0aa32bfd91fd546115a60c77e6e8098cd4debf8f33cb9f9"
OXEN_SPEND_PUB_KEY   = "9834c238ebecb78b1f30115c50b956e9e5e0d86072c61d57e65ee04f9c650b40"
OXEN_VIEW_PRIV_KEY   = "5f51194e0f839ee32fdd85765be009b1fceb70e78204e4bfa3010e2ade61fc0d"
OXEN_SPEND_PRIV_KEY  = "0ac3dc5fff3a7a303b893a50119ff2da3125f6a51b980e409d6c8a3a3f7ec80b"
OXEN_ADDRESS         = "LAiDu7ELmuxQGf3mVdndGRg86zFSUGNa8FhjryejJQDpBrsJB6kXwtMbEkXAa7C2D2CikE9dQL6iTSZNVRgKHrppV9hJvmu"
OXEN_TESTNET_ADDRESS = "T6TSSrs8R9dXhbssUTkYjaFYAwddJW7Sm5ufhvmHWV1n2tB715p3P2sYFC1bBUWYpecg2HF4MXZ3jNWYx4HFMawV2bcKuAhsP"

def test_public_keys(monero):
    (view_pub_key,
     spend_pub_key,
     address) = monero.get_public_keys()  # type: bytes, bytes, str

    assert view_pub_key == bytes.fromhex(OXEN_VIEW_PUB_KEY)
    assert spend_pub_key == bytes.fromhex(OXEN_SPEND_PUB_KEY)
    assert address == (OXEN_TESTNET_ADDRESS)

def test_private_view_key(monero, button):
    view_priv_key: bytes = monero.get_private_view_key(button)

    assert view_priv_key == bytes.fromhex(OXEN_VIEW_PRIV_KEY)

def test_keygen_and_verify(monero):
    pub_key, _priv_key = monero.generate_keypair()  # type: bytes, bytes

    assert monero.verify_key(_priv_key, pub_key) is True


def test_key_image(monero):
    expected_key_img: bytes = bytes.fromhex("b0d5e19411f97c4974217d210f8d50d74731bc062fdb0cf690136ee16d7daa9c")

    _priv_key: bytes = bytes.fromhex("38306180e44a3ca14f4f18b505bce76330a7b03df8c8611ac9bd4ed70c6ce454")
    pub_key: bytes = bytes.fromhex("3cad24457b5b505674af0296976ea36baeab28407bc6f4441ee220aa78900296")

    key_image: bytes = monero.generate_key_image(_priv_key=_priv_key,
                                                 pub_key=pub_key)

    assert expected_key_img == key_image


def test_put_key(monero):
    priv_view_key: bytes = bytes.fromhex(OXEN_VIEW_PRIV_KEY)
    pub_view_key: bytes = bytes.fromhex(OXEN_VIEW_PUB_KEY)
    priv_spend_key: bytes = bytes.fromhex(OXEN_SPEND_PRIV_KEY)
    pub_spend_key: bytes = bytes.fromhex(OXEN_SPEND_PUB_KEY)
    address: str = (OXEN_TESTNET_ADDRESS)

    monero.put_key(priv_view_key=priv_view_key,
                   pub_view_key=pub_view_key,
                   priv_spend_key=priv_spend_key,
                   pub_spend_key=pub_spend_key,
                   address=address)


def test_gen_key_derivation(monero):
    # 8 * r.G
    expected_key_derivation: bytes = bytes.fromhex("4e178167e7d8f3c955cc6db27d81ae60645d50700bfd6acfda0df1011fc82580")
    # r
    _priv_key: bytes = bytes.fromhex("38306180e44a3ca14f4f18b505bce76330a7b03df8c8611ac9bd4ed70c6ce454")
    # r.G
    pub_key: bytes = bytes.fromhex("3cad24457b5b505674af0296976ea36baeab28407bc6f4441ee220aa78900296")

    key_derivation: bytes = monero.gen_key_derivation(
        pub_key=pub_key,
        _priv_key=_priv_key
    )

    assert expected_key_derivation == key_derivation # decrypt _d_in

def test_unlock_signature(monero, button):
    _priv_key: bytes = bytes.fromhex("38306180e44a3ca14f4f18b505bce76330a7b03df8c8611ac9bd4ed70c6ce454")
    pub_key: bytes = bytes.fromhex("3cad24457b5b505674af0296976ea36baeab28407bc6f4441ee220aa78900296")

    monero.generate_unlock_signature(button, _priv_key=_priv_key, pub_key=pub_key)
    monero.reset_and_get_version(b"10.0.0")

def test_ons_signature(monero, button):
    monero.generate_ons_signature(button, name="hello")
    monero.reset_and_get_version(b"10.0.0")

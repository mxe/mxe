#include <cryptopp/cryptlib.h>
#include <cryptopp/osrng.h>
#include <cryptopp/secblock.h>
#include <cryptopp/sha.h>
#include <cryptopp/sha3.h>
#include <cryptopp/base64.h>
#include <cryptopp/filters.h>
#include <cryptopp/gcm.h>
#include <cryptopp/rsa.h>
#include <cryptopp/pssr.h>

int main() {
    {
        CryptoPP::SHA512 sha2;
        unsigned char digest[CryptoPP::SHA512::DIGESTSIZE];
        sha2.Final(digest);
    }

    {
        std::string data;
        const CryptoPP::SecByteBlock key;
        const CryptoPP::SecByteBlock iv;

        CryptoPP::SecByteBlock ret(0, CryptoPP::AES::MAX_KEYLENGTH);
        CryptoPP::StringSource(data, true, new CryptoPP::HashFilter(*(new CryptoPP::SHA3_512), new CryptoPP::ArraySink(ret, CryptoPP::AES::MAX_KEYLENGTH)));
        CryptoPP::GCM< CryptoPP::AES, CryptoPP::GCM_64K_Tables >::Encryption pwenc;
        pwenc.SetKeyWithIV(key.data(), key.size(), iv.data(), iv.size());
        std::string cipher;
        CryptoPP::StringSource(data, true, new CryptoPP::AuthenticatedEncryptionFilter(pwenc, new CryptoPP::StringSink(cipher), false, 16));
    }

    {
        const CryptoPP::SecByteBlock key;
        const CryptoPP::SecByteBlock iv;
        CryptoPP::GCM< CryptoPP::AES, CryptoPP::GCM_64K_Tables >::Decryption pwdec;
        pwdec.SetKeyWithIV(key.data(), key.size(), iv.data(), iv.size());
    }

    {
        CryptoPP::SecByteBlock ret(0, CryptoPP::AES::BLOCKSIZE);
        std::string str;
        CryptoPP::StringSource(str, true, new CryptoPP::Base64Decoder(new CryptoPP::ArraySink(ret, CryptoPP::AES::BLOCKSIZE)));
    }

    return 0;
}

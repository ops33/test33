#!/usr/bin/env bash

#1ks returner chain31
MIX_CLI1="docker exec ${NODE1} /root/chain33-cli "
#1jr  authorize chain32
MIX_CLI2="docker exec ${NODE2} /root/chain33-cli "
#1nl receiver  chain30
MIX_CLI3="docker exec ${NODE4} /root/chain33-cli "

xsedfix=""
if [ "$(uname)" == "Darwin" ]; then
    xsedfix=".bak"
fi

# shellcheck source=/dev/null
#source test-rpc.sh

function mix_set_wallet() {
    echo "=========== # mix set wallet ============="
    #1KSBd17H7ZK8iT37aJztFB22XGwsPTdwE4
    mix_import_wallet "${MIX_CLI1}" "0x6da92a632ab7deb67d38c0f6560bcfed28167998f6496db64c258d5e8393a81b" "returner"
    #1JRNjdEqp4LJ5fqycUBm9ayCKSeeskgMKR
    mix_import_wallet "${MIX_CLI2}" "0x19c069234f9d3e61135fefbeb7791b149cdf6af536f26bebb310d4cd22c3fee4" "authorizer"
    #1NLHPEcbTWWxxU3dGUZBhayjrCHD3psX7k
    mix_import_wallet "${MIX_CLI3}" "0x7a80a1f75d7360c6123c32a78ecf978c1ac55636f87892df38d8b85a9aeff115" "receiver1"
    #1MCftFynyvG2F4ED5mdHYgziDxx6vDrScs
    mix_import_key "${MIX_CLI3}" "0xcacb1f5d51700aea07fca2246ab43b0917d70405c65edea9b5063d72eb5c6b71" "receiver2"

    mix_enable_privacy

}

function mix_import_wallet() {
    local lable=$3
    echo "=========== # save seed to wallet ============="
    result=$(${1} seed save -p 1314fuzamei -s "tortoise main civil member grace happy century convince father cage beach hip maid merry rib" | jq ".isok")
    if [ "${result}" = "false" ]; then
        echo "save seed to wallet error seed, result: ${result}"
        exit 1
    fi

    echo "=========== # unlock wallet ============="
    result=$(${1} wallet unlock -p 1314fuzamei -t 0 | jq ".isok")
    if [ "${result}" = "false" ]; then
        exit 1
    fi

    echo "=========== # import private key ============="
    echo "key: ${2}"
    result=$(${1} account import_key -k "${2}" -l "$lable" | jq ".label")
    if [ -z "${result}" ]; then
        exit 1
    fi

    echo "=========== # wallet status ============="
    ${1} wallet status
}

function mix_import_key() {
    local lable=$3
    echo "=========== # import private key ============="
    echo "key: ${2}"
    result=$(${1} account import_key -k "${2}" -l "$lable" | jq ".label")
    if [ -z "${result}" ]; then
        exit 1
    fi
}

function mix_enable_privacy() {
    ${MIX_CLI1} mix wallet enable -a 1KSBd17H7ZK8iT37aJztFB22XGwsPTdwE4
    ${MIX_CLI2} mix wallet enable -a 1JRNjdEqp4LJ5fqycUBm9ayCKSeeskgMKR
    ${MIX_CLI3} mix wallet enable -a "1NLHPEcbTWWxxU3dGUZBhayjrCHD3psX7k,1MCftFynyvG2F4ED5mdHYgziDxx6vDrScs"

}
function mix_transfer() {
    echo "=========== # mix chain transfer ============="

    ${CLI} send coins send_exec -a 10 -e mix -k 4257D8692EF7FE13C68B65D6A52F03933DB2FA5CE8FAF210B5B8B80C721CED01

    ##config mix key
    ${CLI} send coins transfer -a 10 -n transfer -t 1KSBd17H7ZK8iT37aJztFB22XGwsPTdwE4 -k 4257D8692EF7FE13C68B65D6A52F03933DB2FA5CE8FAF210B5B8B80C721CED01
    #authorize
    ${CLI} send coins transfer -a 10 -n transfer -t 1JRNjdEqp4LJ5fqycUBm9ayCKSeeskgMKR -k 4257D8692EF7FE13C68B65D6A52F03933DB2FA5CE8FAF210B5B8B80C721CED01
    #receiver
    ${CLI} send coins transfer -a 10 -n transfer -t 1NLHPEcbTWWxxU3dGUZBhayjrCHD3psX7k -k 4257D8692EF7FE13C68B65D6A52F03933DB2FA5CE8FAF210B5B8B80C721CED01
    ${CLI} send coins transfer -a 10 -n transfer -t 1MCftFynyvG2F4ED5mdHYgziDxx6vDrScs -k 4257D8692EF7FE13C68B65D6A52F03933DB2FA5CE8FAF210B5B8B80C721CED01

    #receiver key config
    #12q
    ${CLI} send mix config register -r 6828502228622121242962846647254323777568535293334252387427096385571037136275 -e fd1383f79872c41d9af716e64f4a72653faff01858a58122d6a8480ae1eafb04 -a 12qyocayNF7Lv6C9qW4avxs2E7U41fKSfv -k 4257D8692EF7FE13C68B65D6A52F03933DB2FA5CE8FAF210B5B8B80C721CED01
    #14k
    ${CLI} send mix config register -r 19618555102674542426188842632653510836841656859537346801180550073357423415124 -e 001a01b0e39a4e06a6a0470a8436be3d6107ce7312d7c56d41fccb91ffa2031c -a 14KEKbYtKKQm4wMthSK9J4La4nAiidGozt -k CC38546E9E659D15E6B4893F0AB32A06D103931A8230B0BDE71459D2B27D6944
    ##1ks
    ${CLI} send mix config register -r 7922952968605110993699808851901993086405084846049488287958179300126299607225 -e 78e2dd2c33f9cd7a94b69962a164da935e91c3c7fef8cfbf810491a128ef396b -a 1KSBd17H7ZK8iT37aJztFB22XGwsPTdwE4 -k 0x6da92a632ab7deb67d38c0f6560bcfed28167998f6496db64c258d5e8393a81b
    #1jr
    ${CLI} send mix config register -r 15841547877266309152336489543198284578462047449743379483021378876113912204480 -e e5362c31a903cd5522c4b84c324f90e96851292194fdfb33a8a1244bf1bb9f13 -a 1JRNjdEqp4LJ5fqycUBm9ayCKSeeskgMKR -k 0x19c069234f9d3e61135fefbeb7791b149cdf6af536f26bebb310d4cd22c3fee4
    #1nl
    ${CLI} send mix config register -r 1499328046806813717988379826525346013601394010052157072491414645500411978017 -e 0abaa15456580365b90f84f22186f99250f4198f8df7319bcced1606085a1e01 -a 1NLHPEcbTWWxxU3dGUZBhayjrCHD3psX7k -k 0x7a80a1f75d7360c6123c32a78ecf978c1ac55636f87892df38d8b85a9aeff115

    ${CLI} send mix config register -r 7166643181671374870524536201432214798965258692016821447324045928745450625215 -e a97592e700eb0f87c5738b35c8d460ce33a4a59bde6128081ddd042c3c262f76 -a 1MCftFynyvG2F4ED5mdHYgziDxx6vDrScs -k 0xcacb1f5d51700aea07fca2246ab43b0917d70405c65edea9b5063d72eb5c6b71

    ##config deposit circuit vk
    ${CLI} send mix config vk -c 0 -z 1f8b08000000000000ff6c51795053eb15ff4e7281e0f086f5098ff7221114509692581441b4611111c160559055960b449280240842adb22b8bb2094a0551912aa853d08a452bd2a9a0b6022e55c74e519246a86804b57a04f47612c4ce74fad76fbeb3fc96efb0f509db97c96303186da533c449bbc5b2e4207a3730f90428007f600a09b00204c0946b910f4c2501235166bc449c10284bcf54c881a923842c640ad8006c9a2f98dd0096af1b30c50458be7c2d12e2c814b10158f4725d990d2c1f3760f61360f9f0bfa2408b84f09812dda060b60c2ca11b30a5045842be1609b1640e008081bf8496d23285aea70f1c4268a68c0de025576464262878b9bc8038a9342e844ee6c5cb04eecb5d0304c2a424b18cf6e2f9d112c5ff69f0f6cca604cedc2630070970e6c6b52f421631156c00cedc926e840510ae730bdb66330898436c00ee372b41bcc8e8af62fcff8a5512008020606a0921364c0d0bc0e47fe7b44d60aab5ba553add6ff5ea39ddd2595dedd7cc670eb3003891d17245865896acbd0d1811f285b261f2b55a141e0cb7b2cb5650edb824f244cad4c47a677cb79d9f3af5278f179fceaa06a59e13a140a1e16052f395a5279fe3dd5daf4b7c827f27c3965a8db9c42a568956cd1569b6966b34444bd656dd347cc6e1d5396c7655c9f5e679b762a85bf4d63b6dc6e3683e154f697e9d900d14662bd4cea71f769860daaf9e29ad7e5f4630708c2ffca3dbeb22341067b4bee93adfaa63fbebd588fb6b3f0812b1d1f042e1b5d6e66348d78f979ab3252a5cb8e831a97d193108149aced4bdfbe866f102b3cb9c573f3cd583b8c0a37d6fe391ad13e8c0bd292de84bc9224417f556fb83f4bb9ad17eec513f393a62b7f11e5e0d77e106e7d4cbd1f17ec1314596e21250382a6ee82e81db3cac1cbc6c5a6716f21794e839af0f2e6fb1409e1337356a91c24ce76e68ec3d377d7fad06472a2e5dfce870d1057d068523aedce275e812c95bb7e2674da78142faec8cc3631bcb30dc6cd9dd417ff75a0f9b2637ab0d0a6346d15594f45e31fac3351d5b8da5bd5cffb6d20377da08e61936c4b6a1cf1249596e8c4883662182ebde669272a030e7173762854fcda3d1652235ae6fbbe9306a869e4e9e3c7a60086d565c7137aec997135d58a030f183e9b0d71beb1cecf922d967b7ab780d3a58efda1059ff3210ad8397b9de342fb5060a6704ab948eaa497d0c88c813559e18106268cdcec20df6515de894f1a863ba6b8385cedf49ae6f9b5e627704ae2e6f5c5d3becf80a237f7c78e08972b0131dbb970ac63a0b95406191c86ba86ce6ed760c1f8ebfdc1013b516190ff5a6b0c6f43cfcf1d6b9e9c8a74577bfdec23fe2efe53e71337fc347ead1fec495ce6a9ceaeb332eff94db8c40e7b6557f1fa7010a8befddf68f3d7e5c8d92dc54e9ab8190f14ff9675c3ae6cb5468ec6eb0addbfe70b3cedc33bf7962cde26732c4d223e951c6b41c43db1bc2e78ff45aa1f9be36eaf829f942a0d07695fab9881e2358909fd56568726112853baa944dde45ada8d7f253dbb48745b6eef3d840e1991ddd4e752bfb3568edf95b16e768423dfee374f89e9ea43f44a3b5eb0d5159c9f81aa0f09893af2ad33d7b0be6d8d92efba567340f6d9a0ff5f23a1d2b70e96f060aa5fd7f5611a03086ebfc990afcc11e1f74da5e36ce085a8e575b8cab07bd5bab90ea0a335ac0242502856f72345b64de03121c7bffd387fb862987f19fcec985574e4def442b2b7dffe755c9095ab225bd597eff3a58a1c4c5df63a8a9e7f528d43f62ee961a96e887862396df755c3b6f0714f2df0e0cfb35f956a388256ffdf9b0751ef6ee55e9494d3e37a1e59de97fc38bde294280cd094953d0ebe2e429fa42695aa64cc1d918e21f1b16b8c99ffc270000ffff603a413108060000 -k 4257D8692EF7FE13C68B65D6A52F03933DB2FA5CE8FAF210B5B8B80C721CED01
    ##config withdraw vk
    ${CLI} send mix config vk -c 1 -z 1f8b08000000000000ff6c51795093671a7f9fe4230d1a15224705c508b845442520ba8a42498c8051ea8180656345fc20c190484850504428208756a11e8834d80d663d285854c6455d0705d68a2e5a0b54915a8ecaacb25e94f5316abf9d2f48776667fffacdfb1cbfe37db83cc29532d95c004114ad5325a4ab3489723a1d981c0214800c985c029c503f60f6b02806663f01c14ac346b52a3e5cb3c5a04f05e61021641af33917804b8bfd46368023f505269f00472a6691102f268f0bc0a1e759cb5ce0487c812920c09188dfa31f8b848898ddd641bf913270427c812922c00911b34888335308001fc8d47432add15b7b3ce0134233c55c80c054bdce10af176d1785c62527c745d089a28d1abf8079b343fd421212541a3a50b48456ebff4f4394399212f8a39bc07c41803f3acebe08f164f67201f8a34bd6110e408cd52dac1bc9e0c7ece3024cf9dd8a5c14ab782f26feafd87e02002007e60021642af32507c0ee7fe7d82630a5ac6e8955f7f77ae9a86ed1882efb354ecc410e003f5691aad7a93489ec6d4040c86fd44f4c0eab45e12187da976e973aabd1609719e9bd7e7e3d862b266ccefdb2d88cfc6de6575b87172c060ac34f788ea76ebcedc42237fb17e3e70e34a278d1bf1fdbbb19fa519074fc68439a5d1661d9d28f4df0ba1a552cc54f7f21394be53307f06ceef449bb1206f720e772e3b46a557713507876f79a28a540198ccf85fab4825f2c4d981677fd9213d40a10247f9d27b3bd61b4b2694f9676c6ce9afa161d25f2e3073687ea50d6973fe540a47e2c728dd75fb6bdae3c0714ba24a698e65d72e8c4ccaf5fa65efea7b01ee70cb62462c87205daad9924fb3ee0761c21d6ac70abac3f68da15231e98fb8af9a02ce52b6c444515efeefa4014c6dd7c9066bce00d143eb333276f2bfabc0a677a78fd1679adfa28ba1b5f4b2ddf9fea43f76f331774a9fc5badeedcae79d5dc0af639843faa4b9eb53ff97339da563de9d1b41e7b8393d3164dfe35d04309140e2b3cebb76524987068e87a073743f402a34abe49bc27a91122372b5aeb5f3cff9d956da7474f53cd3a37172c684f1faea14d6d98a48a5c1814ebf00edd9cb5a6e045d93380c287cbd5bb453b3e2c45bed3706d94a3d20605ce6dd2b1376c2ea27df4acd28e6bfb7389352c50e871bf3da95aba54820de3a06d7b952909a7381dc1757fea35a1f041c599b13d55dd40e1969b8e3197fed1558bd5852edc85e27d0c1e3978b5f2c7ae9f3538ee62d8daa91794df8ca4ed79d46cd8d94e630bf793def696d077d81db9a94c360414baca2abd7c6c6eca81c2ee7ee17c5e5653d2eb8d2dde0ecbb29bf13196c2b0c7e06514cc0ce63fb5ef5efafe14eee54b66c2ed53c518b48a1fb3baf3b010b38e7ee178e77a4a310a9f0c99ff55b8b50428347977f9da3fec50e2e0ca079399882b9e287e53985ef807d88b3e675f1dd605ae1bb29ab33c13edd207ac7d81d3eb6225b6b5eeade86df9587238758c33dafa9bfd1a88e318a05013b03eafa2313319d396f795df3b33e482cb368d3fd6d27bad1f79572ed43f4affa1cefa79364061c8dc5d374c4f7136fec55c10b63d6222852736c4d9449b3df27186d673d58c0fd36380c2f3f93d2b94ab3e6d47c71503b67b8dcdcdf89d7c41fc361551e19c57cfa77f3b58ee4180c28a8b6a1f4d59c30614a5c406145df13e81cb02b79e74ceddf8314e38b628eaa974ee65a0509193974bf6fdfd34bafb6484259794203eef73b50bf85b5617f2440e5bca3c17b4b0643ba3e7f7d59f32f2b06671ac4b6f6b228d3fc4db6cb8630a32be1e0abb5fd7f2f82e5018e3ab769a762e7c32f29ad6dece769e65c2ca239b732c735a0770a2daa971c9cae1cf582ef9f99f024e3f6d4841b3ff8a3da136a78370383bbfeeeeb984669c7ae6966bc67dea3950b87052de573513f30ee2d8f57f7cd46e5155e28e3bf11f7df7ab220067b7f576081a62642c595271d29c299d05fe7877cf47e1272dd96538e6ade55447c5bd12e49bfb5de5c7f75d050a076e693216ef1808c52eb7a28775c1272a5053effab25c7efe6be4bf7998f1b3cfde0984800d2f24596bd0e8f99f44c83e8b0e5f2d1344ea687ab556ab0f8b4b550a430c7aa556a7caa0d76ca1359bd8d2b808835aad4a50d13af645fe130000ffff37a667a7c7060000 -k 4257D8692EF7FE13C68B65D6A52F03933DB2FA5CE8FAF210B5B8B80C721CED01
    #transferInput
    ${CLI} send mix config vk -c 2 -z 1f8b08000000000000ff6c51795094f719febddf7ee062b8e4f640562428f7ee1a560a465960478e46b985414281fdc0b5bb0bc26ee5d288241c2208180e2347b6296245a64504ac442523a0099682065302040c686c4982e3487c41c3d7d945d369277f3df35ecff3bcefcbd1271c7f369f036018cd64c852b265cad410261bd8e304680009b0ef13a0760b813da94501b015040c43d54972597290325dadca04b68610b2892de000701881706502287f3eb08504287f811609d9ca7ec001a018912ecd01ca8f0f6c3101ca4ff00a855a2484c716e91a852b69a0c47c604f10a0c4022d1262cd9600c02a899c51304a95aea60f5c4218b69403e093a9ca5027ab78b9bcdd890a45e21e269597a4147a8adc770bc529293225e3c30b60e4aa5f29f08eac6c09dcd793c09613e0be6ed7468438b0651c00eeeb215d0b0510a3730bb12b3b08d9531c00db5fac84f0e2e25f8909fe2b564100004280fd901062c79ea6004cffbf4f5b04b64aab5ba9d3fd255ff55af7c48aaef634566c3505c08d8bcf5465c894a9dadf802121cb7a62f6b8568bc6cac84e72d8d7c1100bfe309c2ee8cbe94597e6f5c3e7caae25a39e32f0eea4f95c0ed09816ece275ade05613debbb9ef54988f9f27faadda35bcaefd6fb1e83aedeca0e96cd844b46cf571d7e9c8fb75df61dd4e1127d83bcb14f916f94349cd9b846816cd17142f58bf0d34e696ad4d5faa94001ed5dc37b9df965a86d529e78a3fbcfc532752ecaaa68d4cf8bc8ead5d3269492eb63dc586cc99566e5b8b0053138b4ea917251de8a609490cb09d6d001a373ca63aff92e7648be6f6eeb6c5212a1106bf1c0c9bc936f7c6ad0e751f6b465c3611a2dbf52d4944686bd0800ddaff66bcb1fb8864022f5e32e96f3bf6b610ad0d367b3e7bee5606347e1569ac3ef30f511eeeb6886ebc3f505b8b8207a331f94d776671cb0475f2d865fb429d3b7e7790666de0d7755812fef3fa86e59e5bf8385aa22a7f366f836b7bff9eaefa486c05347eacf9f1bd1fde31f0c1aefded337bf3a20bb1e1d9a453c56c54079aeb7dd1fa3272728b8e4ddaf2469165666d15362d5d22d2bfce2e6342cebaed1bf517a6d1defb9122a0a6d418683c7f63cdadae3c173d9ca97b5eec51eee1825bbc7071b6a360075aba7ec41f979d6f22ba65814683a100f34f9f04f071aed5d3e4d09f2cabd122fd7c5d99db9326745724d84b34c41068ec1c9bf824bdbba719377e5e98f3a6dde40c565ebfc6bbf47cd40b3788120cb2bf3d5eaff3b7c1ef0dcde3de417d745f476647f44ac7f0c08dc3ad67be3f1a83a68315366eb6cfe781c69a2e876db969a54fd1542fb8e8ca255725064f1fea6b8c588e42d758a387ff1a8a3bf1ea1709fca5b36bbc3fa170f44a7bf2a091340b574dee28352c178fa3435b63ffbf576fcf021a372f4e8d1d546d35462fe1d4f0f268e075742e1c387f74756809ba4962c6db2f58b9e9dc39bbfdde4c11181a8ed641b519c71f2a9df19f7da3dfdc89347642ab2f4ef531bc933f038dcbd44de983390583e88c094355dd11c8ebc95699543d152fda4bdfd30c247da73b9e3ed02809bb7076ff8b7777608fcdd5a6b8dcac293cfce54fd1738ee7a4689a75c378a444d405346eeba8f15ef8e6c513c42de50aabe435bea8f0ffb4aa6e61fa07740c6fbd6bddf8e202d1fef6ec1133618bef34b2ef7efdd03dde7a1fcebe1c0eedff716d041a4decb01dddd9a6061a9b0f7e7efb50dcf745e82c3710bf53536d8905328f9cab1b175bd02c28d2dbf1ca114f2dd9e9c22b8525b96388be0e6dc551f2450a635dfd3d8e2eff3913dfccdadc9cd41f2e071a7d77e10839abf900172e48fdb685ea01aee9bbbccb8e6ffc00cd8cc20e77357e36a625f38d5126877c16df87dbefd5fb3e9ddf1f8f7315ebc3c6a8b776a2e5c52e6e4efecd28a071e08e53f5d6f75336a3d18407f9ed6d5530762ea7bde8f569ff1dda3aeeed9f0a989768c92af3ef74b46696e461ccb586afba3841625cba77d5d6f76eef335c6f213ebded61f53da0d1875d34aa1eb4fc2376a688ef0acce4223c936623da3fbfaf1e9df463d8c85d5ffa6bc91c9a1ccbea6b8fbd4461d041de54d4a312dca9b1700b6ca9bf8d56715eab279c045e4063ecb9785e614f97230e8ddb3c3ad6e7bc84b78ab98b76d3d5ddb8dacea434ece4b7238480be616406c384a7a5a90213330f70f7ee9124ec0b0a979889d5aa036919b21c26229d514ab535a33d6ab95c962263327451c4011923978a15696aa52ae67fa258f29f000000ffff7fdd3e0e2a070000 -k 4257D8692EF7FE13C68B65D6A52F03933DB2FA5CE8FAF210B5B8B80C721CED01
    #transferOutput
    ${CLI} send mix config vk -c 3 -z 1f8b08000000000000ff6c53795454e715ffeecc0b8e040988a23058864a5482b53328102521308088a3ac1621c836f818a61d1ecb0c844541a7b2045904a284260a078f444243596493838c1288a2294903270d614969122ab40a81948b82afe70d929ef6e4afdf79f7bbf7b77cf77b7c03c2f760cff2018c82e964656cba9251c8e87460b50428002f60cf11e0793b005bc8a104d80b048cfc53e42a658c0f9398a251037b891062c3fe9e0fc0a7250eab13c0f310039b4b80e721e190905d6c0e1f80473be9cb7ce049c5c0e613e04925cfd1814342446c9ebed161b50c3c7731b0050478ee120e09d9c2be0d00ebbc54743ccd68f4670620208466cff3015cd49ae494188d2853e41d1d1f1fed4b2b4472c6c1d1698fb7837b6cac92a15d449eb44af33307a2d3ab2941b036096c3101c15a3bf745882d5bc40710ac0de95b7800217ab710ba9ac1812de1036cfbc98a4c1416fe5c4cf25fb10b04004006ec3b84106bb69c0760f2ff7ddc21b0659c6ea95ef7a77ad99a6ec1aa2e7735e6ec451e80202c5cad4956320a6e376044c833ea0cabe5b428cc1e32e9931d731bc1e8f69a3783852f4830e0d0b7bd864f978651b829585b5e3a970a147a4a07cf7e6db2f9d852d50b01994fbc5ad0283c5f7da275d74eb45eceed1d3dfa592ce1c80eb95eeef1fd68b005cfda66a5557db5f5204eb1b333c5eb3227d1a4cf79792afbc309a0f06ad7878bd7b5fc52d4dcaa341ccb7d7300ed5f0c7f6db0738f155a1fb9ffb7f3ae9e7c3d5bb733e3d77e7bab25ee91876e9835a8e842d9b714c3741ae6e146435327c946e90ea070cb97effdd163c2428ba637e79bcf141933b86f8f0b8ed9642ce03a4bc3bf4c1b4b5d09d147cd799dae8cf9ad360dab4ac2824e279c13e3173702986ab92a02ed6607747707dda780c2b611d76ee77d651fe0a507858af428c3719cb9af3b597d25418be656d2b9297e4795de1d3db1b2f489e30f5578bd2bd5398bd73e83a3a75c859fbf78b97a4935ad7b634bc04ea0f0ada39587beac693d85c6b5dec5af375fdb81eb3a7c73827f74bf8a42d9a2e88969b3a59eecdef62097818583a36855f7e7c6bd23bd973073a8492812bb45a2ddc31ebb8fe71aa380c2a6c3db4a22695b5b6477fbed10ffc26f04b50714babf3f7bd6b754712af495f503dc7fb5ba569f10cfc11941c16da42c99a9deac923b387981c4d6cb22929012decd9bd444ff06289c6a895c7ef9c4f84d6c4b69d6ceb7cd6f43a7b73bdb82c6ef4ad126a62bb1a9eda9a3de9e7d71cc6c606c9e19aecf49fef40d92cde2e2d4fbdf0cf61137848ea8df0972e728a050e1b92c504b5712b1fe56f3f6f3bb4b1dd1d03c57346eb5e93b14d6ce9d58aadf9cf87c13ce1989d6dfef77aac58be6f7884503dae0ca62a197b67f7d160a0b6f46c4fcdbfd63a0b0a7d65ef6d75f8319be97f528f6465d6214bafe68ffea44f9fb0b28e6ef7a6d20df40a477f781d9156974ead14034ae78e99decb4cf55e82f4dd8eed29cdc8d3b3514ed7df85a2550281e6d1b8ea971fa149ddefa83ddbfba775ec4efbf0e78a594b54dc7ad8e9bf66ed3768cea6f8f4b127278e19b3b293231be7be3001d3813dc827f6234f50ab7e3fe68feb872ce63afc12250f874e687be80e53b23f840e77940fe51ad31de9657e5adefb9178194e255fbe4e96133c2858d1aeadb600ad358f0a4b4a2bcb1fc1c1ec146d3c756712648edcef1696c481ae49eb1e53f7ed520955d47f13138d21ad51982d92bf2ab8f5fda2745934ff2d3268b0e0a38b2afc67cbe535d69fd0c8bc693fce3bb8eef4756b962735f571d861665a2eae18e876aeea1300ae3d4c6f964746cada93b5d7726035fde5d7e3963a4ff018ac5ed6e8c7af95d8eec9624d07a7e8ba80be9cea2450bbbb87e4c78d42f67473bcbd0dcf461eac6cd5f3c020a278dcc06c61449bd38d4f04ff1c952b9057685ebaef935a995f8cb9ac8fdbdba8c01428012f8f97a451ef709f4da1014a7a45527dde31352184d88c03741431f8a56c7fd4f3994fc270000ffff89296a6769060000 -k 4257D8692EF7FE13C68B65D6A52F03933DB2FA5CE8FAF210B5B8B80C721CED01
    #auth
    ${CLI} send mix config vk -c 4 -z 1f8b08000000000000ff6c517b5493e7197f9fe403a2244a89c14b0563a5e014038905d6c2985c82040aa21525440a09fd80b41069122617071228144cc7451438a0a5038695035527a52d475bb9163a540e058a041d7a86b6bb7070b43e22f8ed24883b67677ffdce73fb5dde976d4dd8814c1e1b807b88d6aa1333d59aa4303a131803010a400a4c0101d65e093046338a812923c08d4c57a5a813649ab474bd0e98338490ad4c3e1b804d8b25cb17c00af400a690002b506c4642b6331fb00158b497a5cd06568007301f126005889fa3c48c84089922cba264b90d2c7f0f604a08b0fcc56624643d530c0036d2143a95d6e82d336be010423327d9003e3abd363d412fcc16ee55a6a62a23e824a14a23f1f412ed95f82726aa35b48f30884ed1ff9f81f0f7cb2981b37209cc1f087056d6cd1521cecc476c00ceca91658505106d710bf2e50c12a6940de0f8c24a985011fb5c4cfc5fb132020010064c2521640b738a0560f7bf7be621301566dd728bee8b7ec58a6ec9b2aef9691c98d32c008e2256a7d7aa3549e6bf012e21cf282363306b5118fb679b70c65eb006efb5ec7a6974d5e4437c1297e8a7fec06a003746482f1a868cb5402137f2f6dcdfbc459fa3a05738683a55398c395b68b746db81dfe1b6f315aaa95fadca2466b63f5dea8e709705b7e398527cf17a505701cef86528ae66707fc2d5f762a90dc73aff0a1446554fe78d1e79f019ce04c4bf54f686751b86a4c7e617ebfb3dd1a9f88bc1463baf1c0b5bc30f616e63cefd3b51b4fb84d27d47ef26bcb5b150b42dc1251c9d4d8f96ee44178e01858ced46e6b45ed58b4c42ab5b50c3d231d40e70e4df45bdd68cbcfe62df94bb5f9f25c49255e9e7f115dcec13e0ccf0b3ace18e605f8c979d130ae6eab2d12935f4ec178ff9ae40e1c87b335622bfbe494c9edb961b3fbb781c3b568dcf1d715c47a395cef434c406ab2cee40341a2ff07b7301f97b0c9ddffa38aec3beede24cf8542b44a1c2747891e7c0070a5f6db3af1b7f1c33886bd639f27ed42aa5989bbbfbead933dddd08edfb474e464a7658d81cd67b7b8eb95251a8735e78ddb7f2181f8d8dce7db32f3ff91cb9b19d3155139e52a0b07fa75c7b0ba01303c603123e5c25edc656438bb0e13da72728c8f9aae469505632b184050a559afb4e891e833fe342fe081e9a14cc62c5eaf56151c5a79ee206eb7d2dbe46d525a0f0daab293e25312379d874f11f3fa97efee33738f17ebda9c6e43087ceffba7fc28be3df65f1576e54d72daeb59bc0f2b23d45f3c36bf93814b7f64cb04ea846d748aaa85c96310714264cb754c75c2efd357a15253797650f75e177792107bd3f698ec2cdaf7fefb6e1e1c7d9cfffc2295e21ae6fd26fc7da78d9a8e8b35db7f1df87834b9a7daf10dcc16efae54068da23a030c9aa612afc6a413de6fdd6d028dff04d16ceff5dee68eccdaa439e9b7da8c0b7966d71f7b2cb5d4dfec9f5ad989adc546d15a309c54db5edaec777f730b8e617dbe145d5e34ca0d0601b0a6bc2d2687c67a6a4a370e1c2252cf0fea72eeaae0720af27ffcb736e824396d7a380426dd6c0ce0677661ef7dd7cffa3d4a567720c1f9c3454664ef5a0b5c1d1e6c175f770a0b0be9fc9589db3b30d5f2b4b87894f67af63c638cfe85a937502d9d5a7fb5ca6276e10a070da46596ebdfffb3bf86eeb95e4a9c24d6bd121f42fbf91f9bcd2846e76fca984523a1828bc5daa38f8b6a2cb154bf7a5bc7bfee3a4b7f1789ef79dcd3d7b6f20e7c1919bbee73debcc64eeafd86ebd1c7dad035d3e71bc2ff48aa23174f78f6fd484b4c4a0dd46d3b74bf6f90e40e11679f38d1a7957048aee756cbe35f1e665346d2d75e7ebeb8690dd32aab810b62bd54c1677ae86efb43d7a1e9302d3f4171eb669b17d8f8b3da31a8bc6cd8955bcafdb3bae01854185dc7581c16f65e2123720e34bc9fe2bf8a8e307595b6f6e155a456eaa2fe7e74a08018ae79fae4f3eaa5567d1214a5db2fd8beaad345af38eb9c53da8a5e903478feacd05675f8434eeb0ec8094fc270000ffff6794568075060000 -k 4257D8692EF7FE13C68B65D6A52F03933DB2FA5CE8FAF210B5B8B80C721CED01

}

function mix_deposit() {

    hash=$(${CLI} send mix deposit -m 1000000000 -p ./gnark/circuit/deposit/ -r 1NLHPEcbTWWxxU3dGUZBhayjrCHD3psX7k -a 1JRNjdEqp4LJ5fqycUBm9ayCKSeeskgMKR -f 1KSBd17H7ZK8iT37aJztFB22XGwsPTdwE4 -e coins -s bty -k 4257D8692EF7FE13C68B65D6A52F03933DB2FA5CE8FAF210B5B8B80C721CED01)
    echo "${hash}"
    query_tx "${CLI}" "${hash}"

    query_note "${MIX_CLI1}" 1KSBd17H7ZK8iT37aJztFB22XGwsPTdwE4 3
    query_note "${MIX_CLI2}" 1JRNjdEqp4LJ5fqycUBm9ayCKSeeskgMKR 3
    query_note "${MIX_CLI3}" 1NLHPEcbTWWxxU3dGUZBhayjrCHD3psX7k 3

    echo "auth"
    authHash=$(${MIX_CLI2} mix wallet notes -a 1JRNjdEqp4LJ5fqycUBm9ayCKSeeskgMKR -s 3 | jq -r ".notes[0].noteHash")
    authKey=$(${MIX_CLI2} mix wallet notes -a 1JRNjdEqp4LJ5fqycUBm9ayCKSeeskgMKR -s 3 | jq -r ".notes[0].secret.returnKey")
    echo "authHash=$authHash,authKey=$authKey"
    hash=$(${MIX_CLI2} send mix auth -n "$authHash" -a "$authKey" -p ./gnark/circuit/authorize/ -e coins -s bty -k 4257D8692EF7FE13C68B65D6A52F03933DB2FA5CE8FAF210B5B8B80C721CED01)
    echo "${hash}"
    query_tx "${MIX_CLI2}" "${hash}"

    query_note "${MIX_CLI1}" 1KSBd17H7ZK8iT37aJztFB22XGwsPTdwE4 1

    echo "transfer to 1NLHPEcbTWWxxU3dGUZBhayjrCHD3psX7k"
    transHash=$(${MIX_CLI1} mix wallet notes -a 1KSBd17H7ZK8iT37aJztFB22XGwsPTdwE4 -s 1 | jq -r ".notes[0].noteHash")
    hash=$(${MIX_CLI1} send mix transfer -m 600000000 -n "$transHash" -t 1NLHPEcbTWWxxU3dGUZBhayjrCHD3psX7k -i ./gnark/circuit/transfer/input/ -o ./gnark/circuit/transfer/output/ -e coins -s bty -k 4257D8692EF7FE13C68B65D6A52F03933DB2FA5CE8FAF210B5B8B80C721CED01)
    echo "${hash}"
    query_tx "${CLI}" "${hash}"

    query_note "${MIX_CLI3}" 1NLHPEcbTWWxxU3dGUZBhayjrCHD3psX7k 1

    echo "withdraw"
    withdrawHash=$(${MIX_CLI3} mix wallet notes -a 1NLHPEcbTWWxxU3dGUZBhayjrCHD3psX7k -s 1 | jq -r ".notes[0].noteHash")
    hash=$(${MIX_CLI3} send mix withdraw -m 600000000 -n "$withdrawHash" -p ./gnark/circuit/withdraw/ -e coins -s bty -k 0x7a80a1f75d7360c6123c32a78ecf978c1ac55636f87892df38d8b85a9aeff115)
    echo "${hash}"
    query_tx "${CLI}" "${hash}"

    query_note "${MIX_CLI3}" 1NLHPEcbTWWxxU3dGUZBhayjrCHD3psX7k 2

    ${CLI} account balance -a 1NLHPEcbTWWxxU3dGUZBhayjrCHD3psX7k -e mix
    balance=$(${CLI} account balance -a 1NLHPEcbTWWxxU3dGUZBhayjrCHD3psX7k -e mix | jq -r ".balance")
    if [ "${balance}" != "6.0000" ]; then
        echo "account 1NLHPEcbTWWxxU3dGUZBhayjrCHD3psX7k should be 6.0000, real is $balance"
        #        exit 1
    fi

}

function mix_token_test() {
    echo "config token fee"
    tokenAddr=$(${CLI} mix query txfee -e token -s GD | jq -r ".data")
    echo "tokenAddr=$tokenAddr"
    hash=$(${CLI} send coins transfer -a 10 -n transfer -t "$tokenAddr" -k 4257D8692EF7FE13C68B65D6A52F03933DB2FA5CE8FAF210B5B8B80C721CED01)
    echo "${hash}"
    query_tx "${CLI}" "${hash}"

    echo "token-blacklist"
    hash=$(${CLI} send config config_tx -o add -c "token-blacklist" -v "BTY" -k 4257D8692EF7FE13C68B65D6A52F03933DB2FA5CE8FAF210B5B8B80C721CED01)
    echo "${hash}"
    query_tx "${CLI}" "${hash}"

    echo "precreate"
    hash=$(${CLI} send token precreate -f 0.001 -i test -n guodunjifen -a 12qyocayNF7Lv6C9qW4avxs2E7U41fKSfv -p 0 -s GD -t 10000 -k 12qyocayNF7Lv6C9qW4avxs2E7U41fKSfv)
    echo "${hash}"
    query_tx "${CLI}" "${hash}"

    echo "finishcreate"
    hash=$(${CLI} send token finish -f 0.001 -a 12qyocayNF7Lv6C9qW4avxs2E7U41fKSfv -s GD -k 12qyocayNF7Lv6C9qW4avxs2E7U41fKSfv)
    echo "${hash}"
    query_tx "${CLI}" "${hash}"

    ${CLI} token created

    echo "send_exec"
    hash=$(${CLI} send token send_exec -a 100 -e mix -s GD -k 12qyocayNF7Lv6C9qW4avxs2E7U41fKSfv)
    echo "${hash}"
    query_tx "${CLI}" "${hash}"

    echo "mix deposit"
    hash=$(${CLI} send mix deposit -m 1000000000 -p ./gnark/circuit/deposit/ -r 1NLHPEcbTWWxxU3dGUZBhayjrCHD3psX7k -e token -s GD -k 4257D8692EF7FE13C68B65D6A52F03933DB2FA5CE8FAF210B5B8B80C721CED01)
    echo "${hash}"
    query_tx "${CLI}" "${hash}"

    query_note "${MIX_CLI3}" 1NLHPEcbTWWxxU3dGUZBhayjrCHD3psX7k 1
    echo "transfer to 1MCftFynyvG2F4ED5mdHYgziDxx6vDrScs"
    transHash=$(${MIX_CLI3} mix wallet notes -a 1NLHPEcbTWWxxU3dGUZBhayjrCHD3psX7k -s 1 | jq -r ".notes[0].noteHash")
    hash=$(${MIX_CLI3} send mix transfer -m 600000000 -n "$transHash" -t 1MCftFynyvG2F4ED5mdHYgziDxx6vDrScs -i ./gnark/circuit/transfer/input/ -o ./gnark/circuit/transfer/output/ -e token -s GD -k 4257D8692EF7FE13C68B65D6A52F03933DB2FA5CE8FAF210B5B8B80C721CED01)
    echo "${hash}"
    query_tx "${CLI}" "${hash}"

    query_note "${MIX_CLI3}" 1MCftFynyvG2F4ED5mdHYgziDxx6vDrScs 1

    echo "withdraw token GD"
    withdrawHash=$(${MIX_CLI3} mix wallet notes -a 1MCftFynyvG2F4ED5mdHYgziDxx6vDrScs -s 1 | jq -r ".notes[0].noteHash")
    hash=$(${MIX_CLI3} send mix withdraw -m 600000000 -n "$withdrawHash" -p ./gnark/circuit/withdraw/ -e token -s GD -k 0xcacb1f5d51700aea07fca2246ab43b0917d70405c65edea9b5063d72eb5c6b71)
    echo "${hash}"
    query_tx "${CLI}" "${hash}"

    query_note "${MIX_CLI3}" 1MCftFynyvG2F4ED5mdHYgziDxx6vDrScs 2

    ${CLI} account balance -a 1MCftFynyvG2F4ED5mdHYgziDxx6vDrScs -e mix
    balance=$(${CLI} asset balance -a 1MCftFynyvG2F4ED5mdHYgziDxx6vDrScs -e mix --asset_exec token --asset_symbol GD | jq -r ".balance")
    if [ "${balance}" != "6.0000" ]; then
        echo "account 1MCftFynyvG2F4ED5mdHYgziDxx6vDrScs should be 6.0000, real is $balance"
        #        exit 1
    fi
}
function query_note() {
    block_wait "${1}" 1

    local times=200
    while true; do
        ret=$(${1} mix wallet notes -a "${2}" -s "${3}" | jq -r ".notes[0].status")
        echo "query wallet notes addr=${2},status=$3 return ${ret} "
        if [ "${ret}" != "${3}" ]; then
            block_wait "${1}" 1
            times=$((times - 1))
            if [ $times -le 0 ]; then
                echo "query notes addr=${2} failed"
                exit 1
            fi
        else
            echo "query notes addr=${2} ,status=$3 success"
            ${1} mix wallet notes -a "${2}" -s "${3}"
            break
        fi
    done
}

function query_tx() {
    block_wait "${1}" 1

    local times=200
    while true; do
        ret=$(${1} tx query -s "${2}" | jq -r ".tx.hash")
        echo "query hash is ${2}, return ${ret} "
        if [ "${ret}" != "${2}" ]; then
            block_wait "${1}" 1
            times=$((times - 1))
            if [ $times -le 0 ]; then
                echo "query tx=$2 failed"
                exit 1
            fi
        else
            echo "query tx=$2  success"
            break
        fi
    done
}

function mix_test() {
    echo "=========== # mix chain test ============="
    mix_deposit
    mix_token_test
}

function mix() {
    if [ "${2}" == "init" ]; then
        echo "mix init"
    elif [ "${2}" == "config" ]; then
        mix_set_wallet
        mix_transfer

    elif
        [ "${2}" == "test" ]
    then
        mix_test "${1}"
    fi

}
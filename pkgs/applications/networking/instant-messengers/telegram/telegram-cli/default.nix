{ stdenv, fetchgit, libconfig, libevent, openssl
, readline, zlib, lua5_2, python, pkgconfig, jansson
, runtimeShell
}:

stdenv.mkDerivation rec {
  name = "telegram-cli-2016-03-23";

  src = fetchgit {
    url = "https://github.com/vysheng/tg.git";
    sha256 = "07sss5cnw2ygd7mp8f5532lmj7qm6ywqf4cjaq5g13i8igzqzwzj";
    rev = "6547c0b21b977b327b3c5e8142963f4bc246187a";
  };

  buildInputs = [
    libconfig libevent openssl readline zlib
    lua5_2 python pkgconfig jansson
  ];
  installPhase = ''
    mkdir -p $out/bin
    cp ./bin/telegram-cli $out/bin/telegram-wo-key
    cp ./tg-server.pub $out/
    cat > $out/bin/telegram-cli <<EOF
    #!${runtimeShell}
    $out/bin/telegram-wo-key -k $out/tg-server.pub "\$@"
    EOF
    chmod +x $out/bin/telegram-cli
  '';

  meta = {
    description = "Command-line interface for Telegram messenger";
    homepage = https://telegram.org/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.jagajaga ];
  };
}

{ nixpkgs }:

final: prev: 

let 
  buildDotnet = attrs: prev.callPackage (import "${nixpkgs}/pkgs/development/compilers/dotnet/build-dotnet.nix" attrs) {};
  buildNetSdk = attrs: buildDotnet (attrs // { type = "sdk"; });
in
{
  dotnet-sdk_6-0-201 = buildNetSdk {
    version = "6.0.201";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c505a449-9ecf-4352-8629-56216f521616/bd6807340faae05b61de340c8bf161e8/dotnet-sdk-6.0.201-linux-x64.tar.gz";
        sha512  = "a4d96b6ca2abb7d71cc2c64282f9bd07cedc52c03d8d6668346ae0cd33a9a670d7185ab0037c8f0ecd6c212141038ed9ea9b19a188d1df2aae10b2683ce818ce";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.19"; sha256 = "1izm1kx4rwi6cp6r6qzjn9h1lmqdcx87yj4gnf291gnabgwpdg9i"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.19"; sha256 = "1r41m93kacyyhgjxmhx84n9wv9c2ckwa8295qa4kj8rn73gg4x28"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.19"; sha256 = "0xf920dcy92gyf1a4ply370m1k82ja9srql5sq7wm2prl1y77wxp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.19"; sha256 = "0slhgkjlwcmz4xjl0x6rwhhcdc6f7hz0vb4lg5ak85inl5m98xa9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.19"; sha256 = "1bq00ff77dj8a87paxxhg9qg3x44hs93vmddms2z2rbcv49wh2ra"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.19"; sha256 = "1dk2sqd4j2lr4xaidl99q1gygly52dz5hjpfqhvzkwq5rhm1q2sx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.19"; sha256 = "1iarfzmjb6rdwkp4s0j8zqk0jjmllii1hhrfkmgjhrf9j7zz4qli"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.19"; sha256 = "0d3l3bbfzqzxrwgif6z7a4h0788nm68m5viz9r3jk4cpkc1p8l5r"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.19"; sha256 = "0ky58h37lprp3idwayvrcyn613pdzli24fx472iql5qvhgcgxg5y"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.19"; sha256 = "0g2dhi7sh7gbwrwcinlkzpal6mys12rw6114scyh8xghfswggshi"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.19"; sha256 = "1nrijf8czcbjpkd3ay2czwxa26cl07mv7sbbz9q32ywfqdw16xpj"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.19"; sha256 = "0flz92scm9a3m08fgq99axh02qjhy14dzivzzf702xm9ipa37gds"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.19"; sha256 = "1mm2czg8mczkdayx0z58qs91xbrqh9frmlmfd64b7424rayayrfd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.19"; sha256 = "0r0q5jd7a0dbc2w767clz460pn6lhvrmimsrn3jqw9irgm7g2xns"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.19"; sha256 = "0r3zdg1rapknp94m2hx42mx8wvyarq24cqdcvzd37wf6nmxmaigb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "6.0.19"; sha256 = "03mgjj0sq8h5k7rhi3g4xvc6w129l99fzipqcpri87gq2v2rq9bc"; })
    ];
  };
}
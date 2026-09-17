'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "5d4d9d7290955a48e5384e5a19ce8389",
"assets/AssetManifest.bin.json": "6a22597af97eb3aa10e2c72f953d2572",
"assets/AssetManifest.json": "906161f6ef7987c048bf8f2ff5ead621",
"assets/assets/images/ai_preview.jpg": "5b0cfb4009832354ed612ba2da410ceb",
"assets/assets/images/app_logo.jpg": "ce1902497366cbcbfa36156de86d024f",
"assets/assets/images/app_logo.png": "78354a853c97338ac80d3af59e282660",
"assets/assets/images/haircut.jpg": "a59a094544654b1921f404b322be7bc9",
"assets/assets/images/interior.jpg": "9507b6c05dc99ff26e544d7757074204",
"assets/assets/images/mens_beard_trim_1788719124431.jpg": "b0de74d681f3ccc07d38cdf3d5e2fb4f",
"assets/assets/images/mens_buzz_cut_1788719143321.jpg": "a160f691f3b6713b20bb6e575dcadfa1",
"assets/assets/images/mens_classic_cut_1788719114039.jpg": "9adbe3b892144ad27ed36f764d18e85a",
"assets/assets/images/mens_signature_fade_1788719100547.jpg": "2f986888370f0a9c6cabce292c8d8e10",
"assets/assets/images/spa.jpg": "eb909c803af9cbd93ffd5f5efdcba343",
"assets/assets/images/stylist.jpg": "f4863ceaec08d9cdd1c50aa83a249d34",
"assets/assets/images/womens_balayage_1788719448747.jpg": "d2ea54729f0e96757720b97c8590fa1c",
"assets/assets/images/womens_bob_cut_1788719460463.jpg": "abff77714b5f002acc03bfd0494ec917",
"assets/assets/images/womens_keratin_spa_1788719436978.jpg": "1ba0d5c9ae5ca9a046378a58bfef5a64",
"assets/assets/images/womens_layer_cut_1788719425375.jpg": "b8812d23d668a7828019fc11e1cb7394",
"assets/FontManifest.json": "65f94acffb0ac2ee75d87cb32190e494",
"assets/fonts/MaterialIcons-Regular.otf": "b3e73b8b777a5282a99d0703f508c81f",
"assets/NOTICES": "c8522d65e17e0672459f9dc749017564",
"assets/packages/lucide_icons/assets/lucide.ttf": "f9ba0b4172a0beabfecd5857b55dfe72",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "dc6c93ceae13c991db2aad78a1d62e52",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"flutter_bootstrap.js": "64c857f27994415367925927752f8795",
"icons/Icon-192.png": "8fad37da1484ce12c9f3f63a937f4f17",
"icons/Icon-512.png": "d5b8b5244ba13a44453015f86bc32ae5",
"icons/Icon-maskable-192.png": "8fad37da1484ce12c9f3f63a937f4f17",
"icons/Icon-maskable-512.png": "d5b8b5244ba13a44453015f86bc32ae5",
"index.html": "69b733a147d9e2db039b8c391afb84c8",
"/": "69b733a147d9e2db039b8c391afb84c8",
"main.dart.js": "322e429196352228ab2e50fdb3af1b60",
"manifest.json": "06aeaadb40eb02c3b40bd7f7a47d2964",
"version.json": "af0b2a2922326520c0286b1801b32fd9"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}

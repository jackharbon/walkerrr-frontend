'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "3d985e4eb55984a6998923ba53fddaf2",
"assets/assets/armors/idle-armor/0.png": "ccaf1a68738fcb81f74c7e8ebc06624d",
"assets/assets/armors/idle-armor/1.png": "43a87de6f2db578e3fdc7f4c1cdcffbe",
"assets/assets/armors/idle-armor/2.png": "bbfc93929a797c9536a0aa30b2ce9b83",
"assets/assets/armors/idle-armor/3.png": "1939006321e0cfda3c4cea4491165e89",
"assets/assets/armors/idle-armor/4.png": "dd19d3ffd881ab5e2d688ca5c5425555",
"assets/assets/armors/idle-armor/5.png": "793b8cbd12b0d0a90e180b48e1699986",
"assets/assets/armors/static-armor/0.gif": "3cf7ecc788446fe6df62342e904bd2f3",
"assets/assets/armors/static-armor/1.gif": "730d2a27b70ab4cd2e2449e3f94823f3",
"assets/assets/armors/static-armor/2.gif": "7b2d77ccc48d6ba2cab58f0f55ceaed3",
"assets/assets/armors/static-armor/3.gif": "9e4f8cfef634e5f24116682316408c8a",
"assets/assets/armors/static-armor/4.gif": "39ae24153665636278a748d7bf1f01b6",
"assets/assets/armors/static-armor/5.gif": "8f76a248dc3bdeef77e46a6b1b63a09d",
"assets/assets/armors/walking-armor/0.gif": "661103788d382b53d21d05ff7f6d0597",
"assets/assets/armors/walking-armor/1.gif": "1cdfc5dd561bd65c6ed2e9f09dfff3f1",
"assets/assets/armors/walking-armor/2.gif": "50e1516b1a22ce8c5711f811a0fe404e",
"assets/assets/armors/walking-armor/3.gif": "8168e12ad65f1df7acc604250b33fe53",
"assets/assets/armors/walking-armor/4.gif": "81c555e1ac1ceecf02a8a9bc4078a9ae",
"assets/assets/armors/walking-armor/5.gif": "a3cc43663df35e60a3ad6f133d59d0e1",
"assets/assets/fonts/CustomIcons.ttf": "f280e294afdefebc7ee6a5808588c535",
"assets/assets/images/background.png": "5931b3cc2cb033f7dea2b259cdb0aba5",
"assets/assets/images/icon_BackPack.png": "ced5fd157e8bd5e19f6e753937339ebd",
"assets/assets/images/icon_Cart.png": "6bd52f63510c0d40664eeb54458735ef",
"assets/assets/images/icon_Flag.png": "765297b0a9daff7fda05106ac05861c4",
"assets/assets/images/icon_Lightning.png": "4b2cd9970793c4860e2d0ea533e933f7",
"assets/assets/images/icon_Settings.png": "6e2e796d41c6d2a2d59b3165bace9a90",
"assets/assets/images/icon_Star.png": "cb047896de6664a4d7e83b3a1fd9e787",
"assets/FontManifest.json": "f8ec27312bf02bf4ac4f918c39934293",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/NOTICES": "486fcbbf2ff6bcea5697bf6374a295df",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "a85fcf6324d3c4d3ae3be1ae4931e9c5",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "1ef16a7443e1be230088e85ab10b4a1b",
"/": "1ef16a7443e1be230088e85ab10b4a1b",
"main.dart.js": "2daa925f1201c3b6ce890542dfaea998",
"manifest.json": "b028bb2dc02e40762646c3f597c65bb4",
"version.json": "cf125f65484de12e0459b507f3df8af0"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
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

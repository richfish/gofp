styleArr = [
  {
    featureType: "water"
    stylers: [color: "#383838"]
  }
  {
    featureType: "landscape"
    stylers: [color: "#08304b"]
  }
  {
    featureType: "poi"
    elementType: "geometry"
    stylers: [
      {
        color: "#0c4152"
      }
      {
        lightness: 5
      }
    ]
  }
  {
    featureType: "road.highway"
    elementType: "geometry.fill"
    stylers: [color: "#000000"]
  }
  {
    featureType: "road.highway"
    elementType: "geometry.stroke"
    stylers: [
      {
        color: "#0b434f"
      }
      {
        lightness: 25
      }
    ]
  }
  {
    featureType: "road.arterial"
    elementType: "geometry.fill"
    stylers: [color: "#000000"]
  }
  {
    featureType: "road.arterial"
    elementType: "geometry.stroke"
    stylers: [
      {
        color: "#0b3d51"
      }
      {
        lightness: 16
      }
    ]
  }
  {
    featureType: "road.local"
    elementType: "geometry"
    stylers: [color: "#000000"]
  }
  {
    elementType: "labels.text.fill"
    stylers: [color: "#ffffff"]
  }
  {
    elementType: "labels.text.stroke"
    stylers: [
      {
        color: "#000000"
      }
      {
        lightness: 13
      }
    ]
  }
  {
    featureType: "transit"
    stylers: [color: "#146474"]
  }
  {
    featureType: "administrative"
    elementType: "geometry.fill"
    stylers: [color: "#000000"]
  }
  {
    featureType: "administrative"
    elementType: "geometry.stroke"
    stylers: [
      {
        color: "#144b53"
      }
      {
        lightness: 14
      }
      {
        weight: 1.4
      }
    ]
  }
]

handler = Gmaps.build('Google')
handler.buildMap {
  provider:
    zoom: 8
    center:
      lat: gon.map_center_lat
      lng: gon.map_center_lng
    backgroundColor: 'black'
    streetViewControl: false
    styles: styleArr
  internal: id: 'theMap'
}, ->
  markers = handler.addMarkers(gon.hash)
  handler.bounds.extendWith markers
  handler.fitMapToBounds() #will zoom in way too much if only 1 point, if multi points, use it

function geolocate() {
  return new Promise((resolve, reject) => {
    navigator.geolocation.getCurrentPosition(
      (position) => {
        resolve(position.coords)
      },
      () => {
        reject()
      }
    )
  })
}

export { geolocate }

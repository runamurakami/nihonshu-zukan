document.addEventListener("turbo:load", () => {

  console.log("map loaded")

  const prefectures = document.querySelectorAll("#japan-map .prefecture")

  prefectures.forEach(pref => {

    const code = pref.dataset.code

    pref.addEventListener("click", () => {
      window.location.href = `/sakes?q[brewery_prefecture_id_eq]=${code}`
    })

  })

})
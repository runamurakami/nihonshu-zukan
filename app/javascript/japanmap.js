document.addEventListener("turbo:load", () => {

  console.log("map loaded")

  const prefectures = document.querySelectorAll(".prefecture")

  prefectures.forEach(pref => {

    pref.addEventListener("click", () => {

      const code = pref.dataset.code
      console.log("prefecture code:", code)

    })

  })

})
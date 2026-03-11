document.addEventListener("turbo:load", () => {

  const prefectures = document.querySelectorAll("#japan-map .prefecture")
  const counts = window.prefectureCounts || {}

  prefectures.forEach(pref => {

    const code = pref.dataset.code
    const count = counts[code] || 0

    let color = "#eeeeee"

    if (count >= 10) {
      color = "#0067C0"
    } else if (count >= 6) {
      color = "#4B95D5"
    } else if (count >= 3) {
      color = "#95C4E9"
    } else if (count >= 1) {
      color = "#E0F2FE"
    } 

    const path = pref.querySelector("path")
    if (path) {
      path.style.fill = color
    }

    pref.addEventListener("click", () => {
      window.location.href = `/sakes?q[brewery_prefecture_id_eq]=${code}`
    })

  })

})
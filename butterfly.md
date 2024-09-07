Click run to generate an image, right here in your browser, in grol code

{% include grol_wasm.html %}
<script>
document.getElementById('input').value = `func ycbcr(angle) {
	angle = PI * angle / 180.
	[190, 128 + 120*sin(angle), 128 + 120*cos(angle)]
}
func butterfly(xsize, ysize) {
	imgName := "canvas"
	canvas := image.new(imgName, xsize, ysize)
	div := 6
	now := time()
	t := 0
	for t < 12*PI {
		x := sin(t) * (pow(E, cos(t)) - 2*cos(4*t) - pow(sin(t/12), 5))
		y := cos(t) * (pow(E, cos(t)) - 2*cos(4*t) - pow(sin(t/12), 5))
		angle := int(t*180./PI) % 360
		color = ycbcr(angle)
		image.set_ycbcr(canvas, int(xsize/2+(xsize/div)*x+0.5), int(ysize/2.5+(ysize/div)*y+0.5), color)
		t = t + 0.001
	}
    print("data:image/png;base64,")
    print(base64(image.png(canvas)))
}
butterfly(400,300)`
resizeTextarea(document.getElementById('input'))
</script>
<hr>
Back to [Top](index.md)

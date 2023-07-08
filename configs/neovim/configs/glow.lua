local status, glow = pcall(require, "glow")
if not status then
	print("Error loading module:", glow)
end

glow.setup({
	border = "none",
	style = "dark",
	pager = false,
	width = 140,
	height = 120,
	width_ratio = 0.8,
	height_ratio = 0.8,
})

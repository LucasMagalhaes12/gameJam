shader_type canvas_item;

uniform float sanity_ratio : hint_range(0.0, 1.0) = 1.0;
uniform float softness : hint_range(0.05, 1.0) = 0.45;
uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	// Calcula a distância de cada pixel até o centro da tela
	vec2 uv = UV - vec2(0.5);
	float dist = length(uv);

	// Quando sanity_ratio = 1.0, o raio é grande e a tela fica totalmente limpa.
	// Conforme cai para 0.0, o raio fecha até o centro e tudo fica preto.
	float radius = mix(-softness, 0.85, sanity_ratio);
	float alpha = smoothstep(radius, radius + softness, dist);

	COLOR = vec4(vignette_color.rgb, alpha * vignette_color.a);
}
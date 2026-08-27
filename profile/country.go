package profile

import (
	"regexp"
	"strings"
)

var countryAliases = map[string][]string{
	"AR": {"argentina", "argentine", "阿根廷"},
	"AU": {"australia", "aussie", "澳大利亚", "澳洲"},
	"BR": {"brazil", "巴西"},
	"CA": {"canada", "加拿大"},
	"CH": {"switzerland", "swiss", "瑞士"},
	"CL": {"chile", "智利"},
	"CN": {"china", "mainland", "中国", "大陆"},
	"DE": {"germany", "frankfurt", "德国", "法兰克福"},
	"EG": {"egypt", "埃及"},
	"ES": {"spain", "madrid", "西班牙", "马德里"},
	"FI": {"finland", "芬兰"},
	"FR": {"france", "paris", "法国", "巴黎"},
	"GB": {"united kingdom", "britain", "england", "london", "uk", "英国", "伦敦"},
	"HK": {"hong kong", "hongkong", "hk", "香港"},
	"ID": {"indonesia", "jakarta", "印尼", "雅加达"},
	"IE": {"ireland", "爱尔兰"},
	"IL": {"israel", "以色列"},
	"IN": {"india", "mumbai", "印度", "孟买"},
	"IT": {"italy", "milan", "意大利", "米兰"},
	"JP": {"japan", "tokyo", "osaka", "jp", "日本", "东京", "大阪"},
	"KR": {"south korea", "korea", "seoul", "kr", "韩国", "首尔"},
	"MO": {"macao", "macau", "澳门"},
	"MX": {"mexico", "墨西哥"},
	"MY": {"malaysia", "kuala lumpur", "my", "马来西亚", "吉隆坡"},
	"NL": {"netherlands", "holland", "amsterdam", "荷兰", "阿姆斯特丹"},
	"NO": {"norway", "挪威"},
	"NZ": {"new zealand", "新西兰"},
	"PH": {"philippines", "manila", "菲律宾", "马尼拉"},
	"PL": {"poland", "warsaw", "波兰", "华沙"},
	"RU": {"russia", "moscow", "俄罗斯", "莫斯科"},
	"SE": {"sweden", "stockholm", "瑞典", "斯德哥尔摩"},
	"SG": {"singapore", "sg", "新加坡", "狮城"},
	"TH": {"thailand", "bangkok", "泰国", "曼谷"},
	"TR": {"turkey", "istanbul", "土耳其", "伊斯坦布尔"},
	"TW": {"taiwan", "taipei", "tw", "台湾", "台北"},
	"UA": {"ukraine", "乌克兰"},
	"US": {"united states", "america", "los angeles", "san jose", "new york", "us", "usa", "美国", "洛杉矶", "圣何塞", "纽约"},
	"VN": {"vietnam", "hanoi", "越南", "河内"},
	"ZA": {"south africa", "南非"},
}

func inferCountryCode(name string) string {
	text := strings.ToLower(strings.TrimSpace(name))
	if text == "" {
		return ""
	}
	if code := countryCodeFromFlag(text); code != "" {
		return code
	}
	for code, aliases := range countryAliases {
		for _, alias := range aliases {
			if containsAlias(text, alias) {
				return code
			}
		}
	}
	return ""
}

func countryCodeFromFlag(text string) string {
	runes := []rune(text)
	for index := 0; index < len(runes)-1; index++ {
		first, second := runes[index], runes[index+1]
		if first >= 0x1F1E6 && first <= 0x1F1FF && second >= 0x1F1E6 && second <= 0x1F1FF {
			return string([]rune{first - 0x1F1E6 + 'A', second - 0x1F1E6 + 'A'})
		}
	}
	return ""
}

func containsAlias(name, alias string) bool {
	if alias == "" {
		return false
	}
	if strings.Contains(alias, " ") || hasNonASCII(alias) {
		return strings.Contains(name, alias)
	}
	return regexp.MustCompile(`(^|[^a-z])` + regexp.QuoteMeta(alias) + `([^a-z]|$)`).MatchString(name)
}

func hasNonASCII(value string) bool {
	for _, r := range value {
		if r > 0x7F {
			return true
		}
	}
	return false
}

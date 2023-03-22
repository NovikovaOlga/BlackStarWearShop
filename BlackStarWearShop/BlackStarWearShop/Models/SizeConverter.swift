
import Foundation

struct SizeConverter { // конвертер размеров (как в проекте фигмы)
    
    // возраст детей прилетает в месяцах/ годах и в росте (СМ). Расширить конвертер - если необходимо.
    static private let sizes = ["XXXS":"38",
                                "XXS":"40",
                                "XS":"42",
                                "S":"44",
                                "M":"46",
                                "L":"48",
                                "XL":"50",
                                "XXL":"52",
                                "XXXL":"54",
                                "4XL":"56",
                                "5XL":"58"]
    
    static subscript(_ size:String) -> String? {
        return sizes[size]
    }
}


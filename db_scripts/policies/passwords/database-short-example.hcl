length = 5

rule "charset" {
  charset = "abcde"
  min-chars = 1
}

rule "charset" {
  charset = "ABCDE"
  min-chars = 1
}

rule "charset" {
  charset = "01234"
  min-chars = 1
}
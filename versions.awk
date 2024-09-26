@load "readfile"

BEGIN {
  versions = readfile("versions.inc")
}

BEGINFILE {
  # Extract the version number from the file path.
  if (match(FILENAME, "^\\./([0-9.]{5,}|main)/(doc|int)/", parts) == 0) {
    print "Serious error detected!" > "/dev/stderr"
    exit 1
  }
  version = parts[1]
  visibility = parts[2]
}

match($0, /(^.* id="projectnumber">)(.*<\/span>)?$/, parts) {
  # Inject the version <select> elements, selecting the current options first.
  pattern = "value=\"("gensub(/\./, "\\\\.", "g", version)"|"visibility")\""
  printf "version: %s\nvisibility: %s\npattern: %s\n", version, visibility, pattern
  printf "%s\n%s    </span>\n", parts[1], gensub(pattern, "\\0 selected", "g", versions)

  if (!parts[2]) {
    print "need to also remove old"
  }
}

{
  print
}

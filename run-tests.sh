set -e
java -Dtest.webdriver.firefox.bin=../artifacts/ci/ff-test-driver -cp "./lib/*" org.scalatest.tools.Runner -oW -p `find lib -iname "casper-core*$1.jar"` -u $1-reports -s com.springer.test.functional.SearchResultsPageExpandedFacetsFirefoxTests

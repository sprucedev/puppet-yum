# = Class: yum::repo::docker
#
# This class installs the official Docker repo
#
class yum::repo::docker (
  $baseurl = undef,
  $stability = 'main',
) {
  case $::operatingsystem {
    'RedHat', 'CentOS', 'Scientific': {
      $release = "centos"
    }
    default: {
      $release = $::operatingsystem
    }
  }

  if $baseurl {
    validate_re(
      $baseurl,
      '^(?:https?|ftp):\/\/[\da-zA-Z-][\da-zA-Z\.-]*\.[a-zA-Z]{2,6}\.?(?:\:[0-9]{1,5})?(?:\/[\w~-]*)*$',
      '$baseurl must be a Clean URL with no query-string, a fully-qualified hostname and no trailing slash.'
    )
    $url = $baseurl
  } else {
    $url = "https://yum.dockerproject.org/repo/$stability/$release/\$releasever"
  }

  yum::managed_yumrepo { 'docker':
    descr          => "Docker repository",
    baseurl        => $url,
    enabled        => 1,
    gpgcheck       => 1,
    failovermethod => 'priority',
    gpgkey         => 'https://yum.dockerproject.org/gpg',
    autokeyimport  => 'yes',
    priority       => 5,
  }

}

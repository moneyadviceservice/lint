module SprocketsSupport
  FIXTURES_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '../..', 'spec',  'fixtures')).freeze

  def fixtures_path(path)
    File.join(FIXTURES_ROOT, path)
  end
end

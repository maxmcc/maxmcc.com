# ATTRIBUTION: Original code from GitHub project episource/jekyll-uncss.

require 'sass' # note: sass is always available as jekyll depends on it
require 'stringio'
require 'tempfile'
require 'json'

module UncssWrapper

  class Error < StandardError; end

  # Run uncss with the given config. See description of uncss's --uncssrc option.
  #   +uncssrc+ the configuration to be used as hash. Will be serialized to json and then passed to uncss using its
  #             --uncssrc option. See github.com/giakki/uncss for details.
  #   +files+   one or more html files/pages to be analyzed. Globs can be used. See github.com/isaacs/node-glob for
  #             details.
  #
  # Returns uncss output, that is css code that is actually being used by the pages that were analyzed.
  def self.uncss(uncssrc, files)
    files = [ files ].flatten

    tempfileUncssrc = Tempfile.new('uncssrc')
    tempfileUncssrc.write(uncssrc.to_json)
    tempfileUncssrc.flush

    begin
      result = `node_modules/.bin/uncss --uncssrc '#{tempfileUncssrc.path}' '#{files.join("' '")}' 2>&1`
    rescue Exception => e
      raise Error, "uncss failed: #{e} :: #{result}"
    ensure
      tempfileUncssrc.close!
    end

    yield(StringIO.new(result)) if block_given?
    result
  end
end

# postprocess already rendered site
Jekyll::Hooks.register(:site, :post_write) do |site|
  config = site.config['uncss'] || {}
  if !config.key?('stylesheets')
    raise "Missing option 'uncss.stylesheets'!"
  end

  files = config.fetch('files', ['**/*.html']).collect {|x| File.join(site.dest, x)}

  config['stylesheets'].each {|s|
    uncssrc = {
      :htmlroot => site.dest,

      # uncss treats absolute stylesheet paths as relative to htmlroot
      :stylesheets => [ File.join('/', s) ],

      # these are optional and will be dropped if nil
      :ignore => config['ignore'],
      :media => config['media'],
      :timeout => config['timeout']
    }.delete_if {|k,v| v == nil}

    essentialCss = UncssWrapper::uncss(uncssrc, files)

    if config['compress']
      essentialCss = Sass.compile(essentialCss, { :style => :compressed })
    end

    File.open(File.join(site.dest, s), 'w') do |f|
      f.write(essentialCss)
    end
  }
end

# frozen_string_literal: true

require "thor"

class Mappings < Thor
  desc "graph", "Render and save flowchart of mappings"
  def graph
    check_for_mmdcli
    mermaid = get_mermaid

    mmd_dir = dir || Sr.data_dir
    FileUtils.mkdir_p(mmd_dir) unless Dir.exist?(mmd_dir)

    mmd_path = File.join(mmd_dir, "mappings.mmd")
    File.open(mmd_path, "w") { |f| f << mermaid }

    pdf_path = File.join(mmd_dir, "mappings.pdf")

    create(mmd_path, pdf_path)
  end

  desc "from", "Render flowchart of mappings from a single source field"
  method_option :sourcefield,
    required: true,
    aliases: "-s",
    type: :string,
    desc: "The source field to output mappings for"
  def from
    check_for_mmdcli
    mermaid = get_mermaid(source: options[:sourcefield])

    mmd_dir = dir || Sr.data_dir
    FileUtils.mkdir_p(mmd_dir) unless Dir.exist?(mmd_dir)

    name = "mappings_from_#{options[:sourcefield]}".tr(" ", "_")

    mmd_path = File.join(mmd_dir, "#{name}.mmd")
    File.open(mmd_path, "w") { |f| f << mermaid }

    pdf_path = File.join(mmd_dir, "#{name}.pdf")

    create(mmd_path, pdf_path)
  end

  desc "to", "Render flowchart of mappings to target field"
  method_option :targetfield,
    required: true,
    aliases: "-t",
    type: :string,
    desc: "Target fields for which to output mappings"
  def to
    check_for_mmdcli
    mermaid = get_mermaid(target: options[:targetfield])

    mmd_dir = dir || Sr.data_dir
    FileUtils.mkdir_p(mmd_dir) unless Dir.exist?(mmd_dir)

    name = "mappings_to_#{options[:targetfield]}".tr(" ", "_")

    mmd_path = File.join(mmd_dir, "#{name}.mmd")
    File.open(mmd_path, "w") { |f| f << mermaid }

    pdf_path = File.join(mmd_dir, "#{name}.pdf")

    create(mmd_path, pdf_path)
  end

  no_commands do
    def check_for_mmdcli
      return if mermaid_cli_installed?

      puts "mmd-cli (Mermaid CLI) command not installed or not found on "\
        "path. See README for installation instructions if you wish to use "\
        "this command."
      exit(1)
    end

    def mermaid_cli_installed?
      result = `which mmd-cli`
      true unless result.empty?
    end

    def dir
      dir = Kiba::Extend::ProjectConfig.graph_dir
      unless dir
        puts "TIP: Add `Kiba::Extend::ProjectConfig.config.graph_dir = "\
          "\"path_to_directory_for_your_project\" to your project config, "\
          "so your graphs can be saved with your other project files."
      end

      dir
    end

    def get_mermaid(source: nil, target: nil)
      return Sr::DrawMappings.new(source: source).mermaid if source
      return Sr::DrawMappings.new(target: target).mermaid if target

      Sr::DrawMappings.new.mermaid
    end

    def create(mmd_path, pdf_path)
      configpath = Kiba::Extend::ProjectConfig.mermaid_config_path
      if configpath
        `mmd-cli -i #{mmd_path} -o #{pdf_path} -f -c #{configpath}`
      else
        `mmd-cli -i #{mmd_path} -o #{pdf_path} -f`
      end

      `open #{pdf_path}`
      exit(0)
    end
  end
end

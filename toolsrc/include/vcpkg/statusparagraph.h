<<<<<<< HEAD
#pragma once

#include <vcpkg/binaryparagraph.h>

#include <unordered_map>

namespace vcpkg
{
    enum class InstallState
    {
        ERROR_STATE,
        NOT_INSTALLED,
        HALF_INSTALLED,
        INSTALLED,
    };

    enum class Want
    {
        ERROR_STATE,
        UNKNOWN,
        INSTALL,
        HOLD,
        DEINSTALL,
        PURGE
    };

    /// <summary>
    /// Installed package metadata
    /// </summary>
    struct StatusParagraph
    {
        StatusParagraph();
        explicit StatusParagraph(std::unordered_map<std::string, std::string>&& fields);

        bool is_installed() const { return want == Want::INSTALL && state == InstallState::INSTALLED; }

        BinaryParagraph package;
        Want want;
        InstallState state;
    };

    void serialize(const StatusParagraph& pgh, std::string& out_str);

    std::string to_string(InstallState f);

    std::string to_string(Want f);

    struct InstalledPackageView
    {
        InstalledPackageView() : core(nullptr) {}

        InstalledPackageView(const StatusParagraph* c, std::vector<const StatusParagraph*>&& fs)
            : core(c), features(std::move(fs))
        {
        }

        std::vector<PackageSpec> dependencies() const;

        const StatusParagraph* core;
        std::vector<const StatusParagraph*> features;
    };
}
=======
#pragma once

#include <vcpkg/binaryparagraph.h>

#include <unordered_map>

namespace vcpkg
{
    enum class InstallState
    {
        ERROR_STATE,
        NOT_INSTALLED,
        HALF_INSTALLED,
        INSTALLED,
    };

    enum class Want
    {
        ERROR_STATE,
        UNKNOWN,
        INSTALL,
        HOLD,
        DEINSTALL,
        PURGE
    };

    /// <summary>
    /// Installed package metadata
    /// </summary>
    struct StatusParagraph
    {
        StatusParagraph() noexcept;
        explicit StatusParagraph(std::unordered_map<std::string, std::string>&& fields);

        bool is_installed() const { return want == Want::INSTALL && state == InstallState::INSTALLED; }

        BinaryParagraph package;
        Want want;
        InstallState state;
    };

    void serialize(const StatusParagraph& pgh, std::string& out_str);

    std::string to_string(InstallState f);

    std::string to_string(Want f);

    struct InstalledPackageView
    {
        InstalledPackageView() noexcept : core(nullptr) {}

        InstalledPackageView(const StatusParagraph* c, std::vector<const StatusParagraph*>&& fs)
            : core(c), features(std::move(fs))
        {
        }

        const PackageSpec& spec() const { return core->package.spec; }
        std::vector<PackageSpec> dependencies() const;

        const StatusParagraph* core;
        std::vector<const StatusParagraph*> features;
    };
}
>>>>>>> upstream/master

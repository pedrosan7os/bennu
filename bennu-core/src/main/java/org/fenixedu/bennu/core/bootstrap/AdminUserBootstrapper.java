package org.fenixedu.bennu.core.bootstrap;

import java.util.Collections;
import java.util.List;
import java.util.Objects;

import org.fenixedu.bennu.core.bootstrap.AdminUserBootstrapper.AdminUserSection;
import org.fenixedu.bennu.core.bootstrap.annotations.Bootstrap;
import org.fenixedu.bennu.core.bootstrap.annotations.Bootstrapper;
import org.fenixedu.bennu.core.bootstrap.annotations.Field;
import org.fenixedu.bennu.core.bootstrap.annotations.FieldType;
import org.fenixedu.bennu.core.bootstrap.annotations.Section;
import org.fenixedu.bennu.core.domain.User;
import org.fenixedu.bennu.core.domain.UserProfile;
import org.fenixedu.bennu.core.groups.Group;

import com.google.common.base.Strings;

@Bootstrapper(bundle = "resources.BennuResources", name = "error.bennu.core.bootstrapper.name", sections = AdminUserSection.class)
public class AdminUserBootstrapper {

    @Bootstrap
    public static List<BootstrapError> bootstrapAdminUser(AdminUserSection section) {
        if (Strings.isNullOrEmpty(section.getAdminPassword())) {
            return Collections.singletonList(new BootstrapError(AdminUserSection.class, "getAdminPassword",
                    "bootstrapper.error.emptyPassword", "resources.BennuResources"));
        }
        if (!Objects.equals(section.getAdminPassword(), section.getAdminPasswordRetyped())) {
            return Collections.singletonList(new BootstrapError(AdminUserSection.class, "getAdminPasswordRetyped",
                    "bootstrapper.error.password", "resources.BennuResources"));
        }

        User adminUser =
                new User(section.getAdminUsername(), new UserProfile(section.getAdminGivenNames(), section.getAdminFamilyNames(),
                        null, section.getAdminUserEmail(), null));
        adminUser.changePassword(section.getAdminPassword());

        Group.managers().mutator().changeGroup(adminUser.groupOf());

        return Collections.emptyList();
    }

    @Section(name = "bootstrapper.admin.name", description = "bootstrapper.admin.description",
            bundle = "resources.BennuResources")
    public static interface AdminUserSection {

        @Field(name = "bootstrapper.admin.username", defaultValue = "admin", order = 1)
        public String getAdminUsername();

        @Field(name = "bootstrapper.admin.adminGivenNames", defaultValue = "Admin", order = 2)
        public String getAdminGivenNames();

        @Field(name = "bootstrapper.admin.adminFamilyNames", defaultValue = "User", order = 3)
        public String getAdminFamilyNames();

        @Field(name = "bootstrapper.admin.email", defaultValue = "noreply@fenixedu.org", fieldType = FieldType.EMAIL, order = 4)
        public String getAdminUserEmail();

        @Field(name = "bootstrapper.admin.password", hint = "bootstrapper.admin.password.hint", defaultValue = "admin",
                fieldType = FieldType.PASSWORD, order = 5)
        public String getAdminPassword();

        @Field(name = "bootstrapper.admin.retypedPassword", defaultValue = "admin", fieldType = FieldType.PASSWORD, order = 6)
        public String getAdminPasswordRetyped();

    }
}

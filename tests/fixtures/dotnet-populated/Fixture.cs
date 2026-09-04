using Xunit;

public static class Fixture
{
    public static int One() => 1;
}

public class FixtureTests
{
    [Fact]
    public void ReturnsOne() => Assert.Equal(1, Fixture.One());
}
